---
title: "Duplicate Logging Azure Application Insights"
date: 2022-10-20T17:35:37+02:00
publishdate: 2022-10-20T17:35:37+02:00
draft: true
author: ["Mart de Graaf"]
tags: ["application insights", "loganalytics workspace", "Azure", "logging", "monitoring", "problemsolving"]
summary: "In this article a problem is solved where in Application insights we encountered duplicate logging."
ShowToc: true
TocOpen: true
draft: false
ShowReadingTime: true
UseHugoToc: false
---

**On a recent project we encountered duplicate logging in Azure Application insights.**

{{< quoteblock >}}
BLURALERT: The information in the screenshots is blurred for some obvious reasons.
{{</ quoteblock >}}
## Problem introduction scope and context
As seen in the screenshot we suffered in the acceptance environment with duplicate exceptions, information, and dependencies. In the development environment, on the left screen, we did not experience this issue.
![Duplicate logging](/images/duplicate-logging.png)

### Plan to solve

To exclude the possibility of a software error we excluded these assumptions:

1. Debugging the application and looking at the outgoing application insights tab.
1. The Azure webapp / Azure function is misconfigured
1. We tested web apps with a single instance. If a single instance generates duplicate logging, it's surely not the instance count.

### The cause
The Application Insights Workspace was configured in diagnostic settings as well it was in the properties the workspace property. See the screenshot for the view from the Azure portal.
![Diagnostic settings](/images/diagnostic-settings.png)

**The actual root cause** 

Why was the Application insights workspace configured duplicate in separate settings and not earlier seen?

#### 1. The correct way - ARM > Workspace property
For the, in my eyes correct, implementation of the properties it was filled by ARM the Infrastructure as code made sure we set the right application insights workspace.

```json {linenos=table}
{
    "type": "microsoft.insights/components",
    "kind": "other",
    "name": "ai-[YOUR-APPLICATION-INSIGHTS-NAME]",
    "apiVersion": "2020-02-02-preview",
    "location": "West Europe",
    "properties": {
        "Application_Type": "web",
        "ApplicationId": "ai-[YOUR-APPLICATION-INSIGHTS-NAME]",
        "WorkspaceResourceId": "law-[YOUR-LOG-ANALYTICS-WORKSPACE-NAME]"
    }
}
```
{{< quoteblock >}}
The naming of Azure resources is done using the [Azure abbreviations guide](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations).
{{</ quoteblock >}}

![Properties Application Insights workspace setting](/images/properties-ai-workspace.png)

#### 2. Azure Policy was enforced on 'Diagnostic settings'
There also was an Azure policy checking that there was a diagnostic setting for sending data to the workspace. Whenever we checked and enforced the Azure Policy we would have duplicate data in our Application Insights Workspace.

## Conclusion

### Difference Application Insights and Log Analytics workspace

Application Insights gives 'insights' into application logging, exceptions, and such. You can use the Kudo query language to fetch data intelligently from Application Insights. The Log Analytics workspace is a set of tables. For the client in this article, the data of the Application insights was forwarded to the Log Analytics workspace. The advantage of the Log Analytics workspace is to query over multiple Application insights as well as data about other resources in azure, such as API management, application gateways, service busses, or firewalls.

In the screenshot below is seen that when you create a new Application Insights resource the Log Analytics Workspace 
![Create Application Insights workspace based](/images/create-ai-workspace-based.png)

{{< quoteblock >}}
The Log Analytics workspace is part of the [Azure Monitor](https://learn.microsoft.com/en-gb/azure/azure-monitor/overview) component in Azure.
{{</ quoteblock >}}


### Benefits and Cost analysis

This change saved the client where I fixed this saved over &euro;1000 in Azure Log Analytic costs. It also saves the annoying bug of having duplicate logging. If you are also having this problem, I hope this article helps. Good logging makes all developers happy.

## Wrap up
Whenever you see duplicate logging in your application insights make sure the configuration is correct. Also, make sure that you're not forcing a policy on the diagnostic settings when you configure it in the properties. Only one upstream to the Log Analytic workspace is required :wink:.


### References

- [Microsoft Learn - Application Insights Duplicate Telemetry](https://learn.microsoft.com/en-us/answers/questions/883344/application-insights-duplicate-telemetry.html)
- [Converting table ApplicationInsights LogAnalytics ](https://learn.microsoft.com/en-us/azure/azure-monitor/app/convert-classic-resource#apptraces)
- [Azure Monitor](https://learn.microsoft.com/en-gb/azure/azure-monitor/overview)