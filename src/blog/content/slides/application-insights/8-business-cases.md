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

```sql {file="business-cases/broken-dapper-sql-queries.kusto"}
```

{{% reveal/note %}}
Kusto level 1
{{% /reveal/note %}}

---

## Count traces per hour

```sql {file="business-cases/count-log-messages-by-hour.kusto"}
```

{{% reveal/note %}}
Kusto level 2
{{% /reveal/note %}}

---

## Exceptions distinct by outerMessage

```sql {file="business-cases/exception-distinct-by-requestpath.kusto"}
```

{{% reveal/note %}}
Kusto level 2

Business case: Data is wrong, some ids fail, which ones?
{{% /reveal/note %}}

---

## Exceptions by occurrence (APPI)

```sql {file="business-cases/exceptions_ai_by_problemId.kusto"}
```

{{% reveal/note %}}
Kusto level 3

Business case: What exceptions occur the most where?
{{% /reveal/note %}}

---

## Exceptions per hour (APPI)

```sql {file="business-cases/exceptions_ai_per_hour.kusto"}
```

{{% reveal/note %}}
Kusto level 3

Business case: When do exceptions occur?
{{% /reveal/note %}}

---

## Exceptions with multiple AI-resources (LAW)

```sql {file="business-cases/exceptions.kusto",highlightjs="1-13|14-16|17-22|23-31"}
```

{{% reveal/note %}}
Kusto level 4

Business case: What exceptions occur the most where?
{{% /reveal/note %}}

---

## Performance by callname

```sql {file="business-cases/performance.kusto"}
```

{{% reveal/note %}}
Kusto level 3

Business case: What exceptions occur the most where?
{{% /reveal/note %}}

---

## Slow running SQL queries

```sql {file="business-cases/slow-running-sql-queries.kusto"}
```

{{% reveal/note %}}
Kusto level 2

Business case: What SQL-queries do not perform?
{{% /reveal/note %}}

---

## Show chain response times

```sql {file="business-cases/chain-responsetime-chart.kusto"}
```

{{% reveal/note %}}
Kusto level 4
{{% /reveal/note %}}

{{% /reveal/section %}}