+++
weight = 7
+++


{{% reveal/section %}}

# Demo application

<!-- Do here a image with context of the Azure resources -->
---

[Deep link to Azure Application Insights](https://portal.azure.com)

{{% reveal/note %}}
Where to link to depends on audience.
{{% /reveal/note %}}
---

# Write Logs

```cs {file="../../posts/verifyLogged-with-xunit/systemUnderTest.cs", highlightjs="4,8,13|10,11"}
```

---

# Unit test your logging

```cs {file="../../posts/verifyLogged-with-xunit/unitTestSolution.cs", highlightjs="3,4|7|10,11"}
```

{{% reveal/note %}}
If you need more info on testing this, please read my blog about the verify.

I had a case where we needed to test the log to test a specific exception that was caught. Some services caught the global Exception type, that was bad :).
{{% /reveal/note %}}

{{% /reveal/section %}}
