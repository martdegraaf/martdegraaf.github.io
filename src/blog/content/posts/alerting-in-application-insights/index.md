---
title: "Alerting in Application Insights"
slug: "alerting-in-application-insights"
date: 2025-05-08T17:11:54+01:00
publishdate: 2025-05-01T17:11:54+01:00
draft: true
author: ["Mart de Graaf"]
tags: ["Bicep", "Azure", "Application Insights", "Alerting"]
summary: "This blog post is about smart alerting and setting up alerting via bicep in Azure Application Insights."
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
    alt: "Alerts in Application insights" # alt text
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

So you have your logging in place in Application Insights and you want to be alerted when something goes wrong. This post will show you how to set up alerting in Azure Application Insights.

## Setting up Smart Alerting in Azure Application Insights

Azure Application Insights has a feature called Smart Detection. This feature can automatically detect anomalies in your data. You can set up alerts based on these anomalies.

To set up Smart Detection in Azure Application Insights, follow these steps:

1. Go to the Azure portal.
2. Navigate to your Application Insights resource.
3. Click on the `Smart Detection` tab.

You can set up alerts based on various metrics, such as:

- Server response time
- Server requests
- Server exceptions
- Server failures

![Smart detection](smart-detection.png#center "Set up Alerting via Smart Detection")

## Custom alerts via Bicep

If you want more control over your alerts, you can use Bicep to define your alerts. Bicep is a domain-specific language for deploying Azure resources declaratively.

Here is an example of how you can define an alert rule that checks if there are more than 0 exception checking frequently.

By creating Action groups, you can define what should happen when the alert is triggered. In this example, we are using a webhook to call a function app. But you can also send an email or call a logic app.

```bicep {linenos=table}
param version string = utcNow('yyMMddHHmm')
var location = resourceGroup().location

resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: 'FunctionActionGroup'
  location: 'Global'
  properties: {
    groupShortName: 'FuncAG'
    enabled: true
    webhookReceivers: [
      {
        name: 'FunctionWebhook'
        // This is obviously a fake URL, replace it with your own
        serviceUri: 'https://my-cool-fnapp.azurewebsites.net/api/HttpTrigger1?code=1234567890'
      }
    ]
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing =  {
  name: 'bicep-appi-mart'
}

resource alert 'Microsoft.Insights/scheduledQueryRules@2021-08-01' = {
  name: 'ExceptionAlert'
  location: location
  properties: {
    description: 'Alert for specific exception'
    enabled: true
    actions: {
      actionGroups: [
        actionGroup.id
      ]
    }
    scopes:[
      applicationInsights.id
    ]
    criteria: {
      allOf: [
        {
          query: 'exceptions | where exceptionType == "Demo.KQL.FunctionsNet9.DemoException"'
          timeAggregation: 'Count'
          
          operator: 'GreaterThan'
          threshold: 0
        }
      ]
    }
    evaluationFrequency: 'PT5M' // every 5 min
    windowSize: 'PT5M'
    severity: 1 //0 Critical, 1 Error, 2 Warning, 3 Informational, 4 Verbose
  }
}

```

### Multiple alerts via Bicep

With bicep you can make some alerts generic and use parameters to make them more flexible. This way you can reuse the same alert for different applications. By using the for loop you can create multiple alerts at once. 

```bicep {linenos=table}
param alerts array = [
  {
    name: 'ExceptionAlert'
    description: 'Alert for specific exception'
    query: 'exceptions | where exceptionType == "Demo.KQL.FunctionsNet9.DemoException"'
    threshold: 0
  }
  {
    name: 'RequestAlert'
    description: 'Alert for specific request'
    query: 'requests | where url contains "api/HttpTrigger1"'
    threshold: 0
  }
]

resource QueryAlerts 'Microsoft.Insights/scheduledQueryRules@2021-08-01' = [for alert in alerts: {
  name: '${alert.name}-${version}'
  location: location
  properties: {
    description: alert.description
    enabled: true
    actions: {
      actionGroups: [
        actionGroup.id
      ]
    }
    scopes:[
      applicationInsights.id
    ]
    criteria: {
      allOf: [
        {
          query: alert.query
          timeAggregation: 'Count'
          
          operator: 'GreaterThan'
          threshold: alert.threshold
        }
      ]
    }
    evaluationFrequency: 'PT5M' // every 5 min
    windowSize: 'PT5M'
    severity: 1 //0 Critical, 1 Error, 2 Warning, 3 Informational, 4 Verbose
  }
}]

```


## Conclusion and Discussion

Setting up alerting in Azure Application Insights is essential to monitor your application's health. By using Smart Detection or defining your alerts via Bicep, you can ensure that you are alerted when something goes wrong.

If you have these alerts set via Bicep, you can also version control them and deploy them via your CI/CD pipeline. This way, you can ensure that your alerts are always in sync with your application. And if seen on Acceptance for example you will fail faster and will iterate sooner.
