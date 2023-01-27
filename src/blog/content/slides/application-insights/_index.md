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


{{% /reveal/section %}}


---

# Sample Kusto query (KQL)

```sql {file="exceptions.kusto",highlightjs="1-10|11,15,16|18"}
```

---

{{% reveal/section %}}

# Demo application

<!-- Do here a image with context of the Azure resources -->
---

[Deep link to Azure Application Insights](https://portal.azure.com)

---

# Log 

```cs
//Code to log to Application insights

```

---

# Unit test your logging

```cs {file="../../posts/verifyLogged-with-xunit/unitTestSolution.cs", highlightjs="1,2|3,4"}
//UNIT TEST CODE
```

{{% /reveal/section %}}


{{% reveal/note %}}
Allemaal notities
{{% /reveal/note %}}

---

# Business cases

{{% reveal/section %}}

# Azure ASync SignalR flow

---

# Async Azure durable function fan out

---

# 

{{% /reveal/section %}}
