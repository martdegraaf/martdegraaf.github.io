---
title: "Alerting in Application Insights"
slug: "alerting-in-application-insights"
date: 2025-03-19T17:36:54+01:00
publishdate: 2025-03-19T17:36:54+01:00
draft: true
author: ["Mart de Graaf"]
tags: ["Bicep", "Azure", "Application Insights"]
summary: "Thi sblog post is about smart alerting and setting up alerting via bicep in Azure Application Insights."
# Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true
---

So you have your logging in place in Application Insights and you want to be alerted when something goes wrong. This post will show you how to set up alerting in Azure Application Insights.

## Setting up Smart Alerting in Azure Application Insights

Azure Application Insights has a feature called Smart Detection. This feature can automatically detect anomalies in your data. You can set up alerts based on these anomalies.

To set up Smart Detection in Azure Application Insights, follow these steps:

1. Go to the Azure portal.
2. Navigate to your Application Insights resource.
3. Click on the `Smart Detection` tab.
4. Click on the `Add rule` button.
5. Configure the rule to your liking.

You can set up alerts based on various metrics, such as:

- Server response time
- Server requests
- Server exceptions
- Server failures

## Custom alerts via Bicep

If you want more control over your alerts, you can use Bicep to define your alerts. Bicep is a domain-specific language for deploying Azure resources declaratively.

Here is an example of how you can define an alert rule that checks if there are more than 10 exception in the last hour written in Bicep:

```bicep {linenos=table}
resource appInsights 'microsoft.insights/components@2020-02-02' = {
  name: 'myAppInsights'
  location: 'westeurope'
  kind: 'web'
  properties: {
    ApplicationId: 'myAppId'
  }
}

resource alertRule 'microsoft.insights/scheduledQueryRules@2020-10-10-preview' = {
  name: 'myAlertRule'
  location: 'westeurope'
  properties: {
    description: 'Alert on more than 10 exceptions in the last hour'
    severity: 3
    enabled: true
    schedule: {
      frequencyInMinutes: 15
      timeWindow: 'PT1H'
    }
    action: {
      severity: 3
      aznsAction: {
        actionGroup: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/microsoft.insights/actionGroups/myActionGroup'
      }
    }
    condition: {
      windowSize: 'PT1H'
      query: 'exceptions | summarize count()'
      threshold: 10
      operator: 'GreaterThan'
    }
  }
}
```
