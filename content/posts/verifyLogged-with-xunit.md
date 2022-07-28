---
title: "VerifyLogged with Xunit"
date: 2022-07-27T15:00:00+02:00
draft: false
author: ["Mart de Graaf"]
tags: ["Azure", "Application Insights", "Monitoring", "Xunit", "FakeItEasy"]
summary: Explains how to test logInformation with Xunit.
ShowToc: true
---

# Introduction
For a client i wanted to test that logError was called.
Consider for example this piece of code below. The catch operation was added to swallow the exception of the delete action. We want to test this behaviour, but still would like to know the logError is being called.

## The system under test
```cs {linenos=table}
public async Task Delete(long sequenceNumber)
{
  _logger.LogInformation("Deleting scheduled message with sequence number `{sequenceNumber}`.", sequenceNumber);
  try
  {
    await _client.Delete(..);
    _logger.LogInformation("Deleted scheduled message with sequence number `{sequenceNumber}`.", sequenceNumber);
  }
  catch (InvalidOperationException ex) when (ex.Message.Equals($"The scheduled message with SequenceNumber = {sequenceNumber} is already being cancelled."))
  {
    _logger.LogError(ex, "Ignored InvalidOperationException for when the message {sequenceNumber} already has been cancelled.", sequenceNumber);
  }
}
```


# Verify that LogError is called

Have you ever tried to verify your logInformation using xUnit. It does not seem to work out of the box as other FakeItEasy.
I tried this code for example, but it just would not work. the throwing of exception has been left out to keep the code sample small.
```cs {linenos=table}
//Arrange
var logger = A.Fake<ILogger<SystemUnderTest>>();
var sut = new SystemUnderTest(logger);

//Act
await sut.Delete(1);

//Assert
A.CallTo(() => logger.LogError(A<string>.Ignored, A<object[]>.Ignored))
    .MustHaveHappenedOnceExactly();
```

# The LoggerExtensions class
The solution was right at hand beacuse my coworker had taught this one out. With his approval i made this blog post. Use the extension as described below.
```cs {linenos=table}
//Arrange
var logger = A.Fake<ILogger<SystemUnderTest>>();
var sut = new SystemUnderTest(logger);

//Act
await sut.Delete(1);

//Assert
logger.VerifyLogged(LogLevel.Information, "This log message should have been called");
logger.VerifyLogged(LogLevel.Error, "Failed to send e-mail");
```
## LoggerExtensions.cs
```cs {linenos=table}
using FakeItEasy;
using Microsoft.Extensions.Logging;
using System;
using System.Linq;
using Xunit.Sdk;

namespace SomeCoolNamespace
public static class LoggerExtensions
{
    public static void VerifyLogged<T>(this ILogger<T> logger, LogLevel level, string logMessage)
    {
        var (found, actualLevel, actualMessage) = logger.VerifyLog(logMessage);
        if (!found)
        {
            throw new XunitException($"No log message found containing '{logMessage}' at any loglevel");
        }

        if (actualLevel != level)
        {
            throw new AssertActualExpectedException($"[{level}] {logMessage}", $"[{actualLevel}] {actualMessage}",
                $"Unexpected log level for log message");
        }
    }

    public static void VerifyNotLogged<T>(this ILogger<T> logger, LogLevel level, string logMessage)
    {
        var (found, actualLevel, actualMessage) = logger.VerifyLog(logMessage);
        if (found && actualLevel == level)
        {
            throw new XunitException($"Log message found containing '{logMessage}' at level {level}{Environment.NewLine}Message: {actualMessage}");
        }
    }

    public static void VerifyNotLoggedAtLevel<T>(this ILogger<T> logger, LogLevel level)
    {
        var call = Fake.GetCalls(logger)
            .FirstOrDefault(call => (LogLevel?)call.Arguments[0] == level);

        if (call != null)
        {
            throw new XunitException($"Log message found at level {level}{Environment.NewLine}Message: {call.Arguments[2]}");
        }
    }
    public static void VerifyLoggedAtLevel<T>(this ILogger<T> logger, LogLevel level)
    {
        var found = Fake.GetCalls(logger)
            .Any(call => (LogLevel?)call.Arguments[0] == level);

        if (found)
        {
            throw new XunitException($"No log message found at level {level}");
        }
    }

    private static (bool found, LogLevel? level, string? message) VerifyLog<T>(this ILogger<T> logger, string message)
    {
        var call = Fake.GetCalls(logger)
            .FirstOrDefault(call => call.Arguments[2].ToString()
            .Contains(message, StringComparison.OrdinalIgnoreCase));

        return (call != null, (LogLevel?)call?.Arguments[0], call?.Arguments[2].ToString());
    }
}
```

# Conclusion
Using this class you will be able to test your logging with Xunit and FakeItEasy.
