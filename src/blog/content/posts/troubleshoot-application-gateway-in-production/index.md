---
title: "Troubleshoot Application Gateway in Production"
slug: "troubleshoot-application-gateway-in-production"
date: 2025-10-17T14:41:57+02:00
publishdate: 2025-10-17T14:41:57+02:00
draft: true
author: ["Mart de Graaf"]
tags: []
summary: "How do you troubleshoot an Application Gateway in production? How can you find false positives?"
# Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true

cover:
    image: "cover.png" # image path/url
    alt: "A towed car, ready to be diagnosed" # alt text
    #caption: "Mart de Graaf - cartoon style." # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

You implemented an Application Gateway with Web Application Firewall (WAF) in front of your web applications in Azure. Everything seems to be working fine, but suddenly you notice some issues. Maybe some users report that they cannot access the application, or you see unusual traffic patterns in your logs. In this blog, we will discuss how to troubleshoot common issues with Application Gateway in production.

## Mr Havinga

Imagine you are Mr. Havinga, the IT manager of a medium-sized company. You want to buy a new phone, but when you try to access the online store, you get a 403 Forbidden error. You are blocked! The firewall blocked you because the request matched a WAF rule. HAVING is a SQL keyword the WAF triggered a SQL Injection rule.It is extremely important to identify false positives and tune your WAF rules accordingly to prevent blocking legitimate traffic.

{{< quoteblock >}}
:face_with_peeking_eyes: "Mr Havinga is not *having* a good day."
{{</ quoteblock >}}

## 403 Forbidden

When users report that they receive a 403 Forbidden error when trying to access the application, it is often due to WAF rules blocking legitimate traffic.

![403](403.gif)

## Investigate in your log analytics workspace

First, check the logs in your Log Analytics workspace. Look for entries that indicate blocked requests. You can filter the logs by status code 403 to see which requests were blocked.

```kusto
AzureDiagnostics
| where ResourceType == "APPLICATIONGATEWAYS"
| where httpStatus_d == "403"
| sort by TimeGenerated desc
```

## Identify the blocking rule

Once you have identified the blocked requests, look for the `ruleId_s` field in the logs. This field indicates which WAF rule blocked the request. You can then look up this rule in the [OWASP ModSecurity Core Rule Set](https://coreruleset.org/) to understand why it was triggered.

To know more about the specific rule that was triggered, you can see the list on [Microsoft Docs](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/application-gateway-crs-rulegroups-rules?tabs=drs21%2Cowasp32).

## Create an exclusion rule

If you determine that the blocking rule is causing false positives, you can create an exclusion rule in your WAF policy. This allows you to exclude specific requests from being evaluated by certain rules.

```bicep {linenos=table,file="waf.bicep"}
```

## Conclusion

By identifying false positives and creating exclusion rules, you can ensure that legitimate traffic is not blocked while still protecting your applications from threats. This is also the reason why I always recommend starting with a WAF in detection mode first, to monitor and tune the rules before enforcing them via prevention mode.

## More reading

- https://alanta.nl/posts/2021/04/manage-waf-rules-for-appgateway
- https://docs.microsoft.com/en-us/azure/web-application-firewall/ag/custom-waf-rules-overview