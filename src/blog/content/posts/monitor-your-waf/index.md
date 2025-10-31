---
title: "Monitor Your Waf using workbooks"
slug: "monitor-your-waf"
date: 2025-10-31T11:12:14+02:00
publishdate: 2025-10-31T11:12:14+02:00
draft: false
author: ["Mart de Graaf"]
tags: ["waf", "application gateway", "monitoring", "azure", "workbooks", "application gateway", "frontdoor"]
summary: "Small blog on how to monitor your WAF using Azure Workbooks."
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
    alt: "Spa Francorchamps - Room with monitors" # alt text
    # caption: "" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

You can monitor your WAF using Azure Monitor. In this blog post, I will share my insights on how to set up monitoring for your WAF using workbooks.

## Set up Azure Workbook

You can use the Azure WAF Monitor Workbook to monitor your WAF. This workbook provides insights into the WAF logs and helps you identify potential issues.

![Workbook for WAF, application gateway sample](workbook.png#center "Workbook for WAF, application gateway sample")

Get the workbook here:
https://github.com/Azure/Azure-Network-Security/tree/master/Azure%20WAF/Workbook%20-%20WAF%20Monitor%20Workbook

You can deploy the workbook using the 'Deploy to Azure' button in the GitHub repository.

You can use this as a base for your custom Workbook.

## Further Reading

- Troubleshoot your Application gateway's WAF. (see [Troubleshoot Application Gateway in Production]({{< ref "troubleshoot-application-gateway-in-production/index.md" >}}))
