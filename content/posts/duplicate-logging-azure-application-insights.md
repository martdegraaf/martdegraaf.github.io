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
BLURALERT: The information in the screenshots are blurred for some obvious reasons.
{{</ quoteblock >}}
## Problem introduction scope and context
As seen in below screenshot we suffered on the ACC environment with duplicate exceptions, information and dependencies. On the DEV environment, the left screen, we did not expirence this issue.
![Duplicate logging](/images/duplicate-logging.png)

### The steps to exclude

To exclude the possibility of a software error we exlcuded these steps.

1. Debugging the application and looking at theoutgoing application insights tab.
1. The Azure webapp / Azure function is misconfigured
1. We could think of that every instance logs something of their own and thus that would be the problem. We checked this with the first.

### The cause
The Application Insights Workspace was configured in diagnostic settings aswell it was in the properties the workspace property. See the screenshot for the view from the Azure portal.
![Diagnostic settings](/images/diagnostic-settings.png)

**The actual root cause** 

Why was the Application insights workspace configured duplicate in seperate settings and not earlier seen?

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

#### 2. Azure Policy was enforced on 'Diagnostic settings'
There also was a Azure policy checking that there was a diagnostic setting for sending data to the workspace. Whenever we checked and enforced the Azure Policy we would have duplicate data in our Application Insights Workspace.

## Conclusion

### Difference Application insights and Log Analytics workspace

Application Insights gives 'insights' in application logging, exceptions and such. You can use the Kudo query language to fetch data intelligent from Application Insights. The Log Analytics workspace is a set of tables. For the client in this article the data of the Application insights was forwarded to the Log Analytics workspace. The advantage of the Log Analytics workspace is to query over multiple Application insights aswell as data about other resources in azure, such as API management, application gateways, servicebusses or firewalls.

{{< quoteblock >}}
The Log Analytics workspace is part of the [Azure Monitor](https://learn.microsoft.com/en-gb/azure/azure-monitor/overview) component in Azure.
{{</ quoteblock >}}

### Where to put the Azure Policy

```json {linenos=table}
{
  "$schema": "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "resources": [
{
      "type": "Microsoft.Authorization/policyDefinitions",
      "apiVersion": "2019-09-01",
      "name": "05FD52F7B895F4FD9DE9ABD11700EE8F",
      "properties": {
        "displayName": "Apply Diagnostic Settings for microsoft.insights/components (web) to a Log Analytics Workspace",
        "mode": "Indexed",
        "description": "This policy automatically deploys diagnostic settings to Apply Diagnostic Settings for microsoft.insights/components (web) to a Log Analytics Workspace.",
        "metadata": {
          "category": "Monitoring"
        },
        "parameters": {
          "profileName": {
            "type": "String",
            "metadata": {
              "displayName": "Profile Name for Config",
              "description": "The profile name Azure Diagnostics"
            }
          },
          "logAnalytics": {
            "type": "string",
            "metadata": {
              "displayName": "logAnalytics",
              "description": "The target Log Analytics Workspace for Azure Diagnostics",
              "strongType": "omsWorkspace"
            }
          },
          "azureRegions": {
            "type": "Array",
            "metadata": {
              "displayName": "Allowed Locations",
              "description": "The list of locations that can be specified when deploying resources",
              "strongType": "location"
            }
          },
          "metricsEnabled": {
            "type": "String",
            "metadata": {
              "displayName": "Enable Metrics",
              "description": "Enable Metrics - True or False"
            },
            "allowedValues": [
              "True",
              "False"
            ],
            "defaultValue": "False"
          },
          "logsEnabled": {
            "type": "String",
            "metadata": {
              "displayName": "Enable Logs",
              "description": "Enable Logs - True or False"
            },
            "allowedValues": [
              "True",
              "False"
            ],
            "defaultValue": "True"
          }
        },
        "policyRule": {
          "if": {
            "allOf": [
              {
                "field": "type",
                "equals": "microsoft.insights/components"
              },
              {
                "field": "location",
                "in": "[[parameters('AzureRegions')]"
              },
              {
                "field": "kind",
                "equals": "web"
              }
            ]
          },
          "then": {
            "effect": "deployIfNotExists",
            "details": {
              "type": "Microsoft.Insights/diagnosticSettings",
              "existenceCondition": {
                "allOf": [
                  {
                    "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                    "equals": "[[parameters('LogsEnabled')]"
                  },
                  {
                    "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                    "equals": "[[parameters('MetricsEnabled')]"
                  },
                  {
                    "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                    "equals": "[[parameters('logAnalytics')]"
                  }
                ]
              },
              "roleDefinitionIds": [
                "/providers/Microsoft.Authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293"
              ],
              "deployment": {
                "properties": {
                  "mode": "incremental",
                  "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                      "name": {
                        "type": "string"
                      },
                      "location": {
                        "type": "string"
                      },
                      "logAnalytics": {
                        "type": "string"
                      },
                      "metricsEnabled": {
                        "type": "string"
                      },
                      "logsEnabled": {
                        "type": "string"
                      },
                      "profileName": {
                        "type": "string"
                      }
                    },
                    "variables": {},
                    "resources": [
                      {
                        "type": "microsoft.insights/components/providers/diagnosticSettings",
                        "apiVersion": "2017-05-01-preview",
                        "name": "[[concat(parameters('name'), '/', 'Microsoft.Insights/', parameters('profileName'))]",
                        "location": "[[parameters('location')]",
                        "properties": {
                          "workspaceId": "[[parameters('logAnalytics')]",
                          "metrics": [
                            {
                              "category": "AllMetrics",
                              "enabled": "[[parameters('metricsEnabled')]",
                              "retentionPolicy": {
                                "enabled": false,
                                "days": 0
                              }
                            }
                          ],
                          "logs": [
                            {
                              "category": "AppAvailabilityResults",
                              "enabled": "[[parameters('logsEnabled')]"
                            },
                            {
                              "category": "AppBrowserTimings",
                              "enabled": "[[parameters('logsEnabled')]"
                            },
                            {
                              "category": "AppEvents",
                              "enabled": "[[parameters('logsEnabled')]"
                            },
                            {
                              "category": "AppMetrics",
                              "enabled": "[[parameters('logsEnabled')]"
                            },
                            {
                              "category": "AppDependencies",
                              "enabled": "[[parameters('logsEnabled')]"
                            },
                            {
                              "category": "AppExceptions",
                              "enabled": "[[parameters('logsEnabled')]"
                            },
                            {
                              "category": "AppPageViews",
                              "enabled": "[[parameters('logsEnabled')]"
                            },
                            {
                              "category": "AppPerformanceCounters",
                              "enabled": "[[parameters('logsEnabled')]"
                            },
                            {
                              "category": "AppRequests",
                              "enabled": "[[parameters('logsEnabled')]"
                            },
                            {
                              "category": "AppSystemEvents",
                              "enabled": "[[parameters('logsEnabled')]"
                            },
                            {
                              "category": "AppTraces",
                              "enabled": "[[parameters('logsEnabled')]"
                            }
                          ]
                        }
                      }
                    ],
                    "outputs": {
                      "policy": {
                        "type": "string",
                        "value": "[[concat(parameters('logAnalytics'), 'configured for diagnostic logs for ', ': ', parameters('name'))]"
                      }
                    }
                  },
                  "parameters": {
                    "logAnalytics": {
                      "value": "[[parameters('logAnalytics')]"
                    },
                    "location": {
                      "value": "[[field('location')]"
                    },
                    "name": {
                      "value": "[[field('name')]"
                    },
                    "metricsEnabled": {
                      "value": "[[parameters('metricsEnabled')]"
                    },
                    "logsEnabled": {
                      "value": "[[parameters('logsEnabled')]"
                    },
                    "profileName": {
                      "value": "[[parameters('profileName')]"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  ]
}
```

## Benefits and Cost analysis

This change saved the client where i fixed this saved over &euro;1000 in Azure Log Analytic costs. It also saves the annoying feature of having duplicate logging in timelines. When you are also having this problem, i hope this article helps. Good logging makes all developers happy.

## Wrap up
Whenever you see duplicate logging in your application insights make sure the configuration is correct. Only one upstream to the Log Analytic workspace is required :wink:.


## References

- [Microsoft Learn - Application Insights Duplicate Telemetry](https://learn.microsoft.com/en-us/answers/questions/883344/application-insights-duplicate-telemetry.html)
- [Converting table ApplicationInsights LogAnalytics ](https://learn.microsoft.com/en-us/azure/azure-monitor/app/convert-classic-resource#apptraces)
- [Azure Monitor](https://learn.microsoft.com/en-gb/azure/azure-monitor/overview)