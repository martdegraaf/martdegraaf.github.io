+++
weight = 7
+++

{{% reveal/section %}}
# Rendering KQL

{{% reveal/note %}}
https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/renderoperator?pivots=azuredataexplorer
{{% /reveal/note %}}

---

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
| render scatterchart with(xcolumn=x)
```

{{% /reveal/section %}}