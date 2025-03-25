---
title: "Log Masking in Application Insights"
slug: "log-masking-in-application-insights"
date: 2025-03-19T17:27:38+01:00
publishdate: 2025-03-19T17:27:38+01:00
draft: true
author: ["Mart de Graaf"]
tags: ["Application Insights", "Azure", "Logging"]
summary: "In this post, we will discuss the methods to mask data in Azure Application Insights."
# Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true

cover:
    image: "cover.png" # image path/url
    alt: "File icon with title log masking" # alt text
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

For building good and reliable software, logging is essential. But not every type of data should be logged. With all the GDRP regulations it's important to take care of your logging.

By default you should not expose data in your logging. But sometimes it can be handy to see your objects in the logs. This post will discuss methods and show you how to mask data in Azure Application Insights.

## Log masking in .NET 8

There are serveral ways to do Log masking in .NET since version 6. Now let's look what is available for us for .NET 8 and higher.

### Logging source generation

By using Source generation for logging you will be able to mask data in your logs. Let's take a look at how.

#### Step 1: Add Microsoft.Extensions.Logging

First, you need to add the `Microsoft.Extensions.Logging` package to your project. You can do this by running the following command in your project directory:

```bash
dotnet add package Microsoft.Extensions.Logging
```

#### Step 2: Use the LogPropertyIgnore in Your Models

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

#### Step 3: Logging or Sending Data

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

See a codesample on GitHub: [Log Masking in Application Insights](https://github.com/martdegraaf/kql-demo/tree/main/source/Demo.KQL.FunctionsNet9/Demo.KQL.FunctionsNet9/SensitiveLogging).

### Log masking using Custom own made code

While researching for log masking in .NET core i stumbled on this older article: https://dev.to/krusty93/hide-sensitive-data-in-azure-application-insights-logs-of-our-aspnet-core-apis-4ji7.

This article describes how to mask data in your logs. The article describes how to use a custom `JsonConverter` to mask sensitive data in your logs. This approach allows you to define which properties should be masked and how they should be masked. You can use this approach to mask sensitive data in your logs while still using the built-in JSON serialization features of .NET.

It feels cheaty to do this. But it is a possible path to mask your logs. Also as you can see in the Performance section of this blog, you should be carefull with this approach.

### Using the Redaction package

The `Redaction` package is a simple and effective way to mask sensitive data in your logs. This package allows you to define a list of properties that should be redacted when logging objects. You can install the package using the following command:

#### Step 1 installing the package

```bash
dotnet add package Microsoft.Extensions.Compliance.Redaction
```

#### Step 2 Create data classification

Create a data classification that defines the properties that should be redacted. You can do this by creating a class that implements the `IDataClassification` interface:

```csharp
using Microsoft.Extensions.Compliance.Redaction;

public class PrivateDataAttribute : DataClassificationAttribute
{
    public PrivateDataAttribute() : base(DataClassifications.PrivateDataClassification) { }
}
```

#### Step 3 Use the data classification

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

#### Step 4 Configure the Redaction Options

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

### Discussion

Personally i am most charmed by the source generation method of logging. The logging is clean and simple enough to use. The redaction package is a more complex way of masking your logs, but has more capabilities to mask and classify different types of data.

## Log masking in .NET Framework 4.8

So you are still using .NET Framework 4.8? No worries, you can still mask data in your logs. You are entitled to use build your own TelemetryInitializer. This way you can mask data in your logs.

### Step 1: Create a TelemetryInitializer

You need to add properties yourself to the request telemetry. You can do this as seen in the code below. This code does not support lists and such, but suit yourself for that. You can even make it recursive if you would like to log nested objects.

```csharp
public class LogData
{
    public void LogObject(RequestTelemetry telemetry, object obj)
    {
        // Get the properties of the object
        var properties = obj.GetType().GetProperties(BindingFlags.Public | BindingFlags.Instance);
        foreach(var property in properties){
            if(!property.canWrite){
                continue;
            }
            var attributes = property.GetCustomAttributes(typeof(SensitiveDataAttribute), true);
            if(attributes.Length > 0){
                telemetry.Properties.Add(property.Name, "****");
            }else{
                // Log the property
                telemetry.Properties.Add(property.Name, property.GetValue(obj).ToString());
            }

        }
        telemetry.Properties.Add(key, properties[key])
    }
}
```

### Step 2: Use the LogObject

```csharp
public class MyController : ControllerBase
{
    public IActionResult MyAction()
    {
        var model = new MyModel
        {
            Name = "John Doe",
            SensitiveData = "Secret123"
        };

        // Log the model (the sensitive data will be masked)
        LogData logData = new LogData();
        var telemetry = HttpContext.Current.Items["Microsoft.ApplicationInsights.RequestTelemetry"] as RequestTelemetry;
        logData.LogObject(telemetry, model); // logdata will be added to telementry client

        return Ok();
    }
}
```

## Conclusion

By creating a custom attribute and a JSON converter, you can effectively mask sensitive properties during serialization in your .NET 8 application. This approach allows you to maintain clean and secure logging practices while still using the built-in JSON serialization features of .NET. Always ensure that you are compliant with data protection regulations when handling sensitive data.

## References

- https://andrewlock.net/behind-logproperties-and-the-new-telemetry-logging-source-generator/
- https://andrewlock.net/exploring-dotnet-6-part-8-improving-logging-performance-with-source-generators/
- [Log Masking](https://zimmergren.net/redacting-sensitive-information-application-insights/)
- https://learn.microsoft.com/en-us/training/modules/dotnet-compliance-cloud-native-applications/
- https://gist.github.com/joperezr/f5f022bcb4d0ce8f077e40e1f77239c8#file-redaction-md
- [dev.to - Hide sensitive data in Azure Application Insights logs of our ASP.NET (Core) APIs](https://dev.to/krusty93/hide-sensitive-data-in-azure-application-insights-logs-of-our-aspnet-core-apis-4ji7)