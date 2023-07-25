---
title: "Learn how to verify the biggest costs of your Log Analytics workspace"
slug: "azure-application-insights-in-control-of-costs"
date: 2023-07-18T18:00:00+02:00
publishdate: 2023-07-18T00:00:00+02:00
draft: false
author: ["Mart de Graaf"]
tags: ["Azure", "Application Insights", "Monitoring", "KQL"]
summary: Explains how to test LogError with Xunit.
ShowToc: true
TocOpen: true
UseHugoToc: true

ShowReadingTime: true
ShowLastModified: false
ShowWordCount: true
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

The first step is to identify the biggest cost tables. You can do this by running the following query:

![Log Analytics Workspace - Logs - Kusto Query Language](log-analytics-logs.png#center "Log Analytics Workspace - Logs - Kusto Query Language")

```sql {linenos=table,file=QueryByTable.kusto}
```

With knowledge about the biggest cost tables, you can start optimizing your logging. In the next sections, I will show you example queries to give insights into logging costs.

## Azure Diagnostic Logs

On many Azure resources, you can configure Log Analytics Workspace as an upstream source. But did you know that this can lead to many logs you have to pay for? A colleague of mine used this query to identify 90% of their costs. By disabling the Azure Diagnostic Logs for Power BI, they saved a lot of money. By running this query you will gain insights into the **amount** of logs ingested per resource.

```sql {linenos=table,file=QueryTableByResourceId.kusto, hl_lines=[4]}
```


## Application traces

Traces are good to hunt bugs. But when a system is running, do you need all Debug logs? Do you even think every log is important?

In this query below I will sort unique logging metrics by Resource and Costs. The most expensive logs are on top. The magic number `2,52` was the price per Gb ingested for Log Analytics. When u insert more than 100Gb which is a lot, you can get discounted pricing. Make sure when you query you think of your scope and environments that also log this trace.

Make sure you configure your log levels correctly. In `appsettings.json` of `host.json`.

```sql {linenos=table,file=AppTracesByCosts.kusto}
```

## Application dependencies

Dependencies are really important. But when saving too much or calling too frequently it can lead up to a lot of money. This query will give you insights into the biggest dependencies, it is a multiply of the number of calls and the size of all dependencies, the same as with traces.

```sql {linenos=table,file=AppDependenciesByCosts.kusto}
```

## Dashboard

By putting the data in a dashboard you will provide your team with an easy way to access these metrics. In my screenshot below there are two of the most important queries, the application traces and the tables.

Make sure to set your dashboard time to a good time scope.

![Tracing costs dashboard](tracing-dashboard.png#center "Tracing costs dashboard")

## Conclusion

When turning on diagnostics make sure it helps the business. Revisit diagnostic settings and make sure you are in control of your costs. Also make sure that when in development, you are critical about the diagnostic settings. When turned on, it won't be turned off soon, because you're the expert!
