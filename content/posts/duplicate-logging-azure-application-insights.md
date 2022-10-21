---
title: "Duplicate Logging Azure Application Insights"
date: 2022-10-30T17:35:37+02:00
publishdate: 2022-10-30T17:35:37+02:00
draft: false
author: ["Mart de Graaf"]
tags: ["application insights", "Azure", "logging", "monitoring", "problemsolving"]
summary: "In this article a problem is solved where in Application insights we encountered duplicate logging."
ShowToc: true
ShowReadingTime: true
---

**On a recent project we encountered duplicate logging in Azure Application insights.**

## The issue
As seen in below screenshot we suffered on the ACC environment with duplicate exceptions, information and dependencies. On the DEV environment, the left screen, we did not expirence this issue.
![Duplicate logging](/images/duplicate-logging.png)

## The steps to exclude

To exclude the possibility of a software error we exlcuded these steps.

1. Debugging the application and looking at theoutgoing application insights tab.
1. The Azure webapp / Azure function is misconfigured
1. We could think of that every instance logs something of their own and thus that would be the problem. We checked this with the first.

## The cause
The Application Insights Workspace was configured in diagnostic settings aswell it was in the properties the workspace property. See the screenshot for the view from the Azure portal.
![Diagnostic settings](/images/diagnostic-settings.png)

## The actual root cause
Why was the Application insights workspace configured duplicate in seperate settings and not earlier seen?
### 1. The correct way - ARM > Workspace property
For the, in my eyes correct, implementation of the properties it was filled by ARM the Infrastructure as code made sure we set the right application insights workspace.

```json
TODO ARM CODE EXAMPLE APPLICATION INSIGHTS + WORKSPACE
```
### 2. Azure Policy was enforced on 'Diagnostic settings'
There also was a Azure policy checking that there was a diagnostic setting for sending data to the workspace. Whenever we checked and enforced the Azure Policy we would have duplicate data in our Application Insights Workspace.

## Benefits and Cost analysis

This change saved the client where i fixed this saved over &euro;1000 in Azure Log Analytic costs. It also saves the annoying feature of having duplicate logging in timelines. I hope that makes many colegea developers happy.

## Wrap up
Whenever you see duplicate logging in your application insights make sure the configuration is correct. 


## References

- [Microsoft issue]()
- Workspaces
- 