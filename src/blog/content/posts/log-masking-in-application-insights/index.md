---
title: "Log Masking in Application Insights"
slug: "log-masking-in-application-insights"
date: 2025-03-19T17:27:38+01:00
publishdate: 2025-03-19T17:27:38+01:00
draft: true
author: ["Mart de Graaf"]
tags: []
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

By default you should not expose data in your logging. But sometimes it can be handy to see your objects in the logs. This post will discuss methods and show you how to mask data in Azure Application Insights.

# .NET 8+ 

When using .NET 8 or higher you can use the `LogMaskingOptions` class to mask data in your logs. This class is part of the `Microsoft.Extensions.Logging` namespace. 

```cs {linenos=table}
public void ConfigureServices(IServiceCollection services)
{
    services.AddLogging(builder =>
    {
        builder.AddApplicationInsights();
        builder.Services.Configure<LogMaskingOptions>(options =>
        {
            options.AddFilter("Password");
            options.AddFilter("Secret");
        });
    });
}
```

## .NET Framework 4.8

So you are still using .NET Framework 4.8? No worries, you can still mask data in your logs.  You can use the 

TODO: Add code snippet for .NET Framework 4.8
