+++
title = "Observability of your cloud software using Azure Application Insights"
outputs = ["Reveal"]
author = "Mart de Graaf"
Private = true
+++

# Basic Azure Application Insights

1. Requests
1. Traces
1. Exceptions
1. Dependencies
1. PageViews

{{% reveal/note %}}
Do some linking to Microsoft Learn.

's' - type 's' to enter speaker mode, which opens a separate window with a time and speaker notes
'o' - type 'o' to enter overview mode and scroll through slide thumbnails
'f' - type 'f' to go into full-screen mode

Practice via Azure Data Explorer. see https://dataexplorer.azure.com/

{{% /reveal/note %}}

---

# Rendering KQL

{{% reveal/note %}}
https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/renderoperator?pivots=azuredataexplorer
{{% /reveal/note %}}

{{% reveal/section %}}

## linechart

```sql
exceptions
| summarize Count()
| render linechart
```

---

## stackedareachart

```sql
exceptions
| summarize Count()
| render stackedareachart
```

---

## scatterchart

```sql
demo_series2
| extend series_fit_2lines(y), series_fit_line(y)
| render  scatterchart  with(xcolumn=x)
```

{{% /reveal/section %}}

---

# Azure ASync SignalR flow

---

# Async Azure durable function fan out
