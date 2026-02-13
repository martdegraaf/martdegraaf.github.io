---
title: "Cleanup Friday - A FinOps Story"
slug: "cleanup-friday"
date: 2026-02-13T13:47:14+01:00
publishdate: 2026-02-13T13:47:14+01:00
draft: false
author: ["Mart de Graaf"]
tags: ["azure", "finops", "cost management", "cleanup", "automation"]
summary: "Cleanup Friday - A FinOps Story: How we saved 1006 meatballs by optimizing our non-production environments and what we learned from it."
# Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: false
ShowWordCount: true

cover:
    image: "cover.jpg" # image path/url
    alt: "Image by [Alexa](https://safesearch.pixabay.com/users/alexas_fotos-686414/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1510597) from [Pixabay](https://safesearch.pixabay.com//?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1510597)" # alt text
    caption: "Image by <a href="https://safesearch.pixabay.com/users/alexas_fotos-686414/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1510597">Alexa</a> from <a href="https://safesearch.pixabay.com//?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1510597">Pixabay</a>" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

> We saved 1006 meatballs!

On 12 February 2026, my client organized a hackathon themed around FinOps. The goal was to come up with innovative solutions to optimize cloud costs for non-production environments.

## Big spenders

During the hackathon, we discovered that our non-production environments were running 24/7, which was a significant contributor to our cloud costs. We also identified three major Azure resources that were particularly expensive:

- Azure App Service
- Azure SQL Database
- Log analytics workspaces

### Azure App Service

Nobody is using the app service on Development at night, so let's save money. We have scripted to downscale the app service plans and turn off app services at night.

To achieve direct results during this hackathon we minified the scope to only the acceptance environment and the second (shadow) region. We only needed this region when we are doing failover testing, wich was already implemented in a pipeline. This meant that we could turn off the app services in this region for the rest of the time, which resulted in significant cost savings, by our calculations we saved 1006 meatballs! 

### Azure SQL Database

We have not done something for our Azure SQL Databases yet, but we discovered that we could potentially save money by switching from DTU based to vCore based pricing. This would allow us to scale down the databases during non-working hours and scale them up when needed. We will explore this option further in the future.

### Log analytics workspaces

We investigated our log analytics workspaces and found that there was already ahead of the hackathon a big ingestion spike was resolved. I would like to reccomend companies to set alerting on the price of their log analytics workspaces, so that they can quickly identify and resolve any unexpected cost spikes.

Also if you are an engineer and looking to save some money on your application insights. I blogged about this topic before:

- [Learn how to verify the biggest costs of your Log Analytics workspace]({{< ref "clean-up-application-insights/index.md" >}}).
- [Duplicate logging in Azure Log Analytics / Application Insights]({{< ref "duplicate-logging-in-azure-application-insights.md" >}}).

## Learnings

I learned three key lessons from this hackathon:

1. **Non-production environments can be a significant cost driver**: It's important to regularly review and optimize non-production environments to avoid unnecessary costs.
2. You think you are doing well, but there is always room for improvement: Even though we had already implemented some cost-saving measures, we still found significant opportunities for further optimization.
3. Quantifying costs by using a relatable metric (like meatballs) can help to communicate the impact of cost-saving measures in a more engaging way.

### 5 lenses of FinOps

The FinOps Framework also has an assesment tool and it has 5 lenses to look at your FinOps maturity:

1. Knowledge: Do teams know what they are spending in the cloud?
2. Process: Is there a process in place to manage cloud costs?
3. Metrics: Are there metrics in place to track cloud costs and identify areas for optimization?
4. Adoption: Is the mindset of cost optimization adopted across the organization?
5. Automation: Are there automated processes in place to optimize cloud costs?

see https://www.finops.org/wg/finops-assessment/ for the full assesment tool and more details on the 5 lenses. They apply a scoring system to assess the maturity of an organization's FinOps practices across these lenses.

In our presentation at the end of the day we shared our findings using these 5 lenses, which helped to structure our learnings and recommendations for future improvements.

## Cleanup Friday

Let's take this habit of cleaning up non-production environments to the next level.

I think it will be perfect to establish a "Cleanup Friday" routine. Clean your desk, clean your cloud environment. Every Friday, we can dedicate time to review and clean up our non-production resources. This can include:

- Deleting unused resources
- Scaling down resources that are not needed at full capacity
- Clean up old deployments and resource groups
- Reviewing and optimizing resource configurations for cost savings

Let's make Cleanup Friday a tradition!

- https://www.finops.org/framework/