---
title: "Apply Ip Restrictions Application Firewall"
slug: "apply-ip-restrictions-application-firewall"
date: 2024-05-15T18:09:39+02:00
publishdate: 2024-05-15T18:09:39+02:00
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

Let's say you have an application gateway deployed in Azure. Behind the application gateway are more than one backend services acting on requests for your costumers.

![Architecture](appgateway.drawio.svg)

## Restricting access

When you want to release new code to production but still want it not exposed to the outside world, you can restrict access to the backend services by IP. This can be done by adding custom rules to your web application firewall policy (also WAF-policy).

### Adding custom rules in the portal

### Adding custom rules with a bicep template

```bicep
resource customRule 'Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies' = {
  name: 'customRule'
  properties: {
    ruleType: 'MatchRule'
    ruleFormat: 'OWASP'
    ruleGroup: 'REQUEST-920-PROTOCOL-ENFORCEMENT'
    ruleId: '920350'
    ruleName: 'Block requests with empty user-agent header'
    action: 'Block'
    priority: 1
    ruleState: 'Enabled'
  }
}

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
