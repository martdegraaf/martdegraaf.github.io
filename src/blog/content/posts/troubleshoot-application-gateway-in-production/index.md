---
title: "Troubleshoot Application Gateway in Production"
slug: "troubleshoot-application-gateway-in-production"
date: 2025-10-17T14:41:57+02:00
publishdate: 2025-10-17T14:41:57+02:00
draft: true
author: ["Mart de Graaf"]
tags: []
summary: "TODO You should fill this ..."
# Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true

cover:
    image: "cover.webp" # image path/url
    alt: "Mart de Graaf - cartoon style." # alt text
    caption: "Mart de Graaf - cartoon style." # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

You implemented an Application Gateway with Web Application Firewall (WAF) in front of your web applications in Azure. Everything seems to be working fine, but suddenly you notice some issues. Maybe some users report that they cannot access the application, or you see unusual traffic patterns in your logs. In this blog, we will discuss how to troubleshoot common issues with Application Gateway in production.

## Mr Havinga

Imagine you are Mr. Havinga, the IT manager of a medium-sized company. You want to buy a new phone, but when you try to access the online store, you get a 403 Forbidden error. You are blocked! The firewall blocked you because the request matched a WAF rule. HAVING is a SQL keyword the WAF triggered a SQL Injection rule. Mr. Havinga is not having a good day. It is extremely important to identify false positives and tune your WAF rules accordingly to prevent blocking legitimate traffic.

## 403 Forbidden

When users report that they receive a 403 Forbidden error when trying to access the application, it is often due to WAF rules blocking legitimate traffic. 


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

## Create an exclusion rule

If you determine that the blocking rule is causing false positives, you can create an exclusion rule in your WAF policy. This allows you to exclude specific requests from being evaluated by certain rules.

```bicep {linenos=table}
module appGatewayWafPolicy 'br/public:avm/res/network/application-gateway/waf-policy:0.7.1' = {
  name: '${deployment().name}-agw-waf-policy'
  scope: resourceGroup()
  params: {
    name: 'agw-waf-policy-${region}-${environment}'
    policySettings: {
      mode: 'Prevention' // 'Detection' or 'Prevention'
      state: 'Enabled'
    }
    exclusionRules: [
      {
        ruleSetType: 'OWASP'
        ruleSetVersion: '3.2'
        ruleGroupName: 'SQLI'
        ruleIds: [942440]
        matchVariable: 'RequestArgNames'
        selectorMatchOperator: 'Equals'
        selector: 'exampleParam'
      }
    ]
  }
}
```
__Intro to the problem__

# System context
__System explained__
```cs {linenos=table}
__insert code here__
```

# Solution
__Solution explained__
```cs {linenos=table}
__insert code here__
```

# Conclusion and discussion
__Solution explained__
```cs {linenos=table}
__insert code here__
```
