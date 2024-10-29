+++
weight = 9
+++

{{% reveal/section %}}

## Azure Diagnostic Settings


---

## Azure Synapse failed trigger runs

```sql {file="business-cases/synapse/trigger-runs.kusto"}
```

{{% reveal/note %}}

Before you see this logging you will need to enable diagnostics settings on your azure synapse workspace.
{{% /reveal/note %}}

---

## Azure Event Grid failed events

```sql {file="business-cases/event-grid/failed-events.kusto"}
```

{{% reveal/note %}}

Before you see this logging you will need to enable diagnostics settings on your azure Event Grid resource.
{{% /reveal/note %}}

---

## Azure Application Gateway Firewall logs

```sql {file="business-cases/application-gateway/firewall-logs.kusto"}
```

{{% reveal/note %}}

Before you see this logging you will need to enable diagnostics settings on your azure Application Gateway resource.

{{% /reveal/note %}}


{{% /reveal/section %}}