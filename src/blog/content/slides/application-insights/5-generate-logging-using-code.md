+++
weight = 5
+++


{{% reveal/section %}}





# Write Logs

```cs {file="../../posts/verifyLogged-with-xunit/systemUnderTest.cs", highlightjs="4-8|9-13|10,12"}
```

---

# Unit test your logging

```cs {file="../../posts/verifyLogged-with-xunit/unitTestSolution.cs", highlightjs="2-3|6|9-10"}
```

{{% reveal/note %}}
If you need more info on testing this, please read my blog about the verify-method.

I had a case where we needed to test the log to test a specific exception that was caught. Some services caught the global Exception type, that was bad :).
{{% /reveal/note %}}

{{% /reveal/section %}}
