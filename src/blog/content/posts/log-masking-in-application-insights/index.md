---
title: "Log Masking in Application Insights"
slug: "log-masking-in-application-insights"
date: 2025-03-19T17:27:38+01:00
publishdate: 2025-03-19T17:27:38+01:00
draft: true
author: ["Mart de Graaf"]
tags: ["Application Insights", "Azure", "Logging"]
summary: "TODO You should fill this ..."
# Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true

cover:
    image: "cover.webp" # image path/url
    alt: "Mart de Graaf - cartoon style." # alt text
    caption: "Mart de Graaf - cartoon style." # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

[Aanleiding]

By default you should not expose data in your logging. But sometimes it can be handy to see your objects in the logs. This post will discuss methods and show you how to mask data in Azure Application Insights.

# .NET 8+ 

There are serveral ways to do Log masking in .NET 8.

## Logging source generation 

By using Source generation for logging you will be able to mask data in your logs. Let's take a look at how.

### Step 1: Add Microsoft.Extensions.Logging

First, you need to add the `Microsoft.Extensions.Logging` package to your project. You can do this by running the following command in your project directory:

```bash
dotnet add package Microsoft.Extensions.Logging
```

### Step 2: Use the LogPropertyIgnore in Your Models

Now you can use the `[LogPropertyIgnore]` in your models to mark properties that should be not be logged.

```csharp
using Microsoft.Extensions.Logging;

public class MyModel
{
        public string Name { get; set; }

        [LogPropertyIgnore]
        public string SensitiveData { get; set; }

        public string? NullableString { get; set; }
}
```

### Step 3: Logging or Sending Data

When you log or send instances of `MyModel`, the `SensitiveData` property will be masked in the JSON output.

```csharp
public class MyController : ControllerBase
{
    private readonly ILogger<MyController> _logger;

    public MyController(ILogger<MyController> logger)
    {
        _logger = logger;
    }

    public IActionResult MyAction()
    {
        var model = new MyModel
        {
            Name = "John Doe",
            SensitiveData = "Secret123"
        };

        // Log the model (the sensitive data will be masked)
            LogMySensitiveModel(_logger, model);

        return Ok();
    }

        [LoggerMessage(
            Level = LogLevel.Information,
            Message = "Logging Sesnsitive model")]
        private static partial void LogMySensitiveModel(ILogger logger, [LogProperties] MyModel model);
}
```

See my codesample on GitHub: [Log Masking in Application Insights](https://github.com/martdegraaf/kql-demo/tree/main/source/Demo.KQL.FunctionsNet9/Demo.KQL.FunctionsNet9/SensitiveLogging).

## Log masking using Obfuscate globally

## Using the Redaction package

The `Redaction` package is a simple and effective way to mask sensitive data in your logs. This package allows you to define a list of properties that should be redacted when logging objects. You can install the package using the following command:

### Step 1 installing the package

```bash
dotnet add package Microsoft.Extensions.Compliance.Redaction
```

### Step 2 Create data classification

Create a data classification that defines the properties that should be redacted. You can do this by creating a class that implements the `IDataClassification` interface:

```csharp
using Microsoft.Extensions.Compliance.Redaction;

public class PrivateDataAttribute : DataClassificationAttribute
{
    public PrivateDataAttribute() : base(DataClassifications.PrivateDataClassification) { }
}
```

### Step 3 Use the data classification

Now you can use the `PrivateDataAttribute` attribute to mark properties that should be redacted:

```csharp
public class MyModel
{
    public string Name { get; set; }

    [PrivateData]
    public string SensitiveData { get; set; }

    public string? NullableString { get; set; }
}
```

### Step 4 Configure the Redaction Options

You can add custom Redactors, and apply them to different classifications of data.

```csharp
public class MyCustomRedactor : Redactor
{
    private const string Stars = "****";

    public override int GetRedactedLength(ReadOnlySpan<char> input) => Stars.Length;

    public override int Redact(ReadOnlySpan<char> source, Span<char> destination)
    {
        Stars.CopyTo(destination);
        return Stars.Length;
    }
}
```

You can configure the redaction options in your `Startup.cs` file:

```csharp
public void ConfigureServices(IServiceCollection services)
{
    services.AddRedaction(options =>
    {
        options.AddDataClassification<DataClassifications.PrivateDataClassification>();
        options.SetRedactor<MyCustomRedactor>(new DataClassificationSet(DataClassifications.OtherDataClassification)); // Set redactor for specific Data Classification
    });
}
```

## Discussion

Personally i am most charmed by the source generation method of logging. The logging is clean and simple enough to use. The redaction package is a more complex way of masking your logs, but has more capabilities to mask and classify different types of data.

## .NET Framework 4.8

So you are still using .NET Framework 4.8? No worries, you can still mask data in your logs. You can use the 

TODO: Add code snippet for .NET Framework 4.8


### Conclusion

By creating a custom attribute and a JSON converter, you can effectively mask sensitive properties during serialization in your .NET 8 application. This approach allows you to maintain clean and secure logging practices while still using the built-in JSON serialization features of .NET. Always ensure that you are compliant with data protection regulations when handling sensitive data.

## References

- [Log Masking](https://zimmergren.net/redacting-sensitive-information-application-insights/)
- https://dev.to/krusty93/hide-sensitive-data-in-azure-application-insights-logs-of-our-aspnet-core-apis-4ji7
- https://learn.microsoft.com/en-us/training/modules/dotnet-compliance-cloud-native-applications/
- https://gist.github.com/joperezr/f5f022bcb4d0ce8f077e40e1f77239c8#file-redaction-md