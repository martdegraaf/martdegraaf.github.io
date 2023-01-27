+++
weight = 8
+++

{{% reveal/section %}}

# Business cases

{{% reveal/note %}}
Business cases where KQL mega helped me.
{{% /reveal/note %}}

---

## Find broken queries

```sql {file="broken-dapper-sql-queries.kusto"}
```

{{% reveal/note %}}
Kusto level 1
{{% /reveal/note %}}

---

## Count traces per hour

```sql {file="count-log-messages-by-hour.kusto"}
```

{{% reveal/note %}}
Kusto level 2
{{% /reveal/note %}}

---

## Exceptions distinct by outerMessage

```sql {file="exception-distinct-by-requestpath.kusto"}
```

{{% reveal/note %}}
Kusto level 2

Business case: Data is wrong, some ids fail, which ones?
{{% /reveal/note %}}

---

## Exceptions by occurrence with multiple AI-resources

```sql {file="exceptions.kusto",highlightjs="1-10|11,15,16|18"}
```

{{% reveal/note %}}
Kusto level 4

Business case: What exceptions occur the most where?
{{% /reveal/note %}}

---

## Performance by callname

```sql {file="performance.kusto"}
```

{{% reveal/note %}}
Kusto level 3

Business case: What exceptions occur the most where?
{{% /reveal/note %}}

---

## Slow running SQL queries

```sql {file="slow-running-sql-queries.kusto"}
```

{{% reveal/note %}}
Kusto level 2

Business case: What SQL-queries do not perform?
{{% /reveal/note %}}

---

## Show chain response times

```sql {file="chain-responsetime-chart.kusto"}
```

{{% reveal/note %}}
Kusto level 4
{{% /reveal/note %}}

{{% /reveal/section %}}