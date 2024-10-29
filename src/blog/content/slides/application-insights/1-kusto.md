+++
weight = 1
+++


{{% reveal/section %}}

![Log Analytics Workspace in Azure](law.drawio.png)

{{% reveal/note %}}

A Log Analytics Workspace has upstream connectors and can be used to write diagnostics to by Application Insights and azure resources

Some upstream resources:

- Power BI
- Grafana
- Azure Defender for Cloud
- Azure Sentinel
- Azure Dashboards
- Azure Workbooks

Costs are per Gb in the LAW, so scaling AI will not affect costs.

see also: https://blog.martdegraaf.nl/posts/azure-application-insights-in-control-of-costs/

{{% /reveal/note %}}

---

## Basic Azure Application Insights

1. requests
1. traces
1. exceptions
1. dependencies
1. pageViews

{{% reveal/note %}}
Deze tabellen vertalen in Log Analytics Workspace naar andere tabelnamen.
{{% /reveal/note %}}

---

## Azure Log Analytics workspace

| appi | LAW |
|---|---|
| requests | AppRequests   |
| traces | AppTraces |
| exceptions | AppExceptions   |
| dependencies | AppDependencies |
| pageViews |  AppPageViews |

{{% reveal/note %}}
https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/tables-category
{{% /reveal/note %}}

---

## Kusto in Microsoft Azure

1. Azure Application Insights and Log Analytics
2. Azure Monitor
3. Azure Resource Graph Explorer

{{% reveal/note %}}
https://en.wikipedia.org/wiki/Azure_Data_Explorer
Wikipedia says Kusto from 2014, and names after the person Cousteau, as a reference to searching in the ocean of data.
{{% /reveal/note %}}

---

## Azure Data Explorer

### Kusto Query Language (KQL)

1. <https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/>
2. <https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/sqlcheatsheet?source=recommendations>


{{% /reveal/section %}}
