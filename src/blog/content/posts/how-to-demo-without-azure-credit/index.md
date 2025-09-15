---
title: "How to Demo Without Azure Credit"
slug: "how-to-demo-without-azure-credit"
date: 2025-09-15T15:36:27+02:00
publishdate: 2025-09-15T15:36:27+02:00
draft: false
author: ["Mart de Graaf"]
tags: ["azure", "speaking", "budget", "demo"]
summary: "My last demo was a disaster because I ran out of Azure credit. Here are some tips to avoid that happening to you."
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
    alt: "Computer on fire - pixel art" # alt text
    caption: "Computer on fire - pixel art" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

On my presentation for the APE Meetup on the 11th of September, I had a demo prepared to show how easy you could build stuff using bicep and Visual Studio Code. A week before i deployed a Application Gateway with a Web Application Firewall (WAF) in front of a simple web app. I have a monthly budget of 150 euro's to spend on Azure credit. And it was all gone just before the demo. Luckily I had a backup subscription with some credit left, but it was nerve wrecking.

## Blog down

After the demo i realized that my blog was down too because the subscription was disabled. I had to move my blog to another subscription and do change the CNAME to the new Static Web App.

So here are some tips to avoid this happening to you.

## Setup a budget and alerts

In the Azure portal you can setup a budget for your subscription. You can set alerts to be send when you reach 50%, 75% and 90% of your budget. This way you will be warned in time.

To learn more about setting up budgets and alerts in Azure, check out the [official Azure documentation on budgets](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/tutorial-acm-create-budgets).

Once you have ran out of credit, you cannot do anything in that subscription anymore, so you cannot create budgets to prevent this from happening right after.

## Automate deletion of resources

If you are doing demos often, you can automate the deletion of resources after a certain time. You can use Azure CLI or PowerShell scripts to delete resources after your demo is done. You can also use Azure Automation or Logic Apps to schedule the deletion of resources. Or just create a pipeline in Azure DevOps or GitHub Actions to do this for you.
