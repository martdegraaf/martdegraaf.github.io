---
title: "Learn how to verify the biggest costs of your Log Analytics workspace"
slug: "azure-application-insights-in-control-of-costs"
date: 2023-09-04T07:00:00+01:00
publishdate: 2023-09-04T07:00:00+01:00
draft: false
author: ["Mart de Graaf"]
tags: ["Azure", "Application Insights", "Monitoring", "KQL"]
summary: Many companies have a huge money bill for application logging. In this blog post, I will show you how to get in control of your Application Insights costs.
ShowToc: true
TocOpen: true
UseHugoToc: true

ShowReadingTime: true
ShowLastModified: false
ShowWordCount: true


cover:
    image: "pexels-pixabay-259027.jpg" # image path/url
    alt: "Hard Cash on a Briefcase - Photo by Pixabay: https://www.pexels.com/photo/hard-cash-on-a-briefcase-259027/" # alt text
    caption: "Hard Cash on a Briefcase  - Photo by Pixabay" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

## Introduction

Cloud costs can be real money wasters, if you log something you will never need, who is responsible for that? While looking at your costs in Azure, you could see Application Insights as a big cost driver. In this blog post, I will show you how to get in control of your Application Insights costs.

{{< quoteblock >}}
**Prior knowledge**

In an earlier post, I showed how to fix duplicate logging and explained how Log Analytics sits on top of Application Insights.

Read the blog post on [How to fix duplicate logging in Application Insights](/posts/duplicate-logging-azure-application-insights).

All KQL queries in this post are based on the Log Analytics workspace.
{{< /quoteblock >}}

## Identify the biggest cost tables

The first step is to identify the biggest cost tables. You can do this by running the following query in your 'Log Analytics Workspace' resource. The payment model is per Gb, so we want to identify the largest tables.

![Log Analytics Workspace - Logs - Kusto Query Language](log-analytics-logs.png#center "Log Analytics Workspace - Logs - Kusto Query Language")

With knowledge about the biggest cost tables, you can start optimizing your logging. In the next sections, I will show you example queries to give insights into logging costs.

```sql {linenos=table,file=QueryByTable.kusto}
```

## Azure Diagnostic Logs

On many Azure resources, you can configure Log Analytics Workspace as an upstream source. But did you know that this can lead to many logs you have to pay for? A colleague of mine used this query to identify and reduce 90% of their costs. By disabling the Azure Diagnostic Logs for Power BI, they saved a lot of money. By running this query you will gain insights into the **amount** of logs ingested per resource.

```sql {linenos=table,file=QueryTableByResourceId.kusto}
```

## Application traces

Traces are good for hunting bugs. But when a system is running, do you need all Debug logs? Do you even think every log is important?

In this query below I will sort unique logging metrics by Resource and Costs. The most expensive logs are on top. The magic number `2,52` was the price per Gb ingested for Log Analytics. When you insert more than 100Gb which is a lot, you can get discounted pricing. Make sure when you query you think of your scope and environments that also log this trace.

Make sure you configure your log levels correctly. In `appsettings.json` of `host.json`.

```sql {linenos=table,file=AppTracesByCosts.kusto}
```

## Application dependencies

Dependencies are really important. But when writing too much dependency logging it can lead to unwanted costs. This query will give you insights into the dependencies that have a great economic footprint in your Log Analytics Workspace. The `EuroCost` is determined by the sum of `_BilledSize` size of all dependencies given in Gb, multiplied by `2,52`.

The `DataTotalSize` field indicates the data size, this can contain for example the Database query when that is enabled in your logging. If this value is big and the count of this dependency is high this might be a hotspot to act on.

```sql {linenos=table,file=AppDependenciesByCosts.kusto}
```

## Health checks

A special mention is for health checks, do you need the full trace and dependency tree for every health check call? Make sure to exclude those unwanted requests and dependencies. You might only consider keeping health check logging when the health check fails and only the health check result.

## Dashboard

By putting the data in a dashboard you will provide your team with an easy way to access these metrics. In my screenshot below there are two of the most important queries, the application traces and the tables.

Make sure to set your dashboard time to a good time scope.

![Tracing costs dashboard](tracing-dashboard.png#center "Tracing costs dashboard")

## Conclusion

When turning on diagnostics make sure it helps the business. Revisit diagnostic settings and make sure you are in control of your costs. Also make sure that when in development, you are critical about the diagnostic settings. When turned on, it won't be turned off soon, because now you're the expert!

## Further reading

- https://azure.microsoft.com/nl-nl/pricing/details/monitor/
