---
title: "Getting Started With Application Gateway"
slug: "getting-started-with-application-gateway"
date: 2025-10-21T14:16:30+02:00
publishdate: 2025-10-21T14:16:30+02:00
draft: false
author: ["Mart de Graaf"]
tags: ["application gateway", "waf", "azure", "bicep", "getting started", "security"]
summary: "How secure are your web applications? Deploy an Azure Application Gateway with Web Application Firewall (WAF). This is a powerful tool to protect your applications while ensuring seamless performance. Let's dive in and explore how you can get started!"
# Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: false
ShowWordCount: true

cover:
    image: "cover.png" # image path/url
    alt: "Routing in the streets of Lisbon" # alt text
    caption: "What route will you take in Lisbon?" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

How secure are your web applications? Deploy an Azure Application Gateway with Web Application Firewall (WAF). This is a powerful tool to protect your applications while ensuring seamless performance. Let's dive in and explore how you can get started!

## Why deploy an Application Gateway?

Have you ever heard about the [OWASP Top 10](https://owasp.org/www-project-top-ten/)? It is a list of the most common web application security risks. Could you even name all ten risks? If not, you are not alone. But you want to protect against these risks, right? An Application Gateway with Web Application Firewall (WAF) can help you with that. It is a managed service that provides a web application firewall to protect your web applications from common threats and vulnerabilities.

### Alternatives

An alternative is using the Azure FrontDoor service. Or look outside of Azure, but I will not discuss those options in this blog. Frontdoor has some additional features like CDN and global load balancing.

## How to migrate to an Application Gateway?

Let's say you have a web application running on Azure App Service. You want to migrate this application to use an Application Gateway with WAF. Here are the steps you need to take:

1. Create a Key Vault to store the SSL/TLS certificates.
2. Create a Vnet and subnet for the Application Gateway.
3. Create a Public IP Address for the Application Gateway.
4. Create a new Application Gateway with WAF enabled.
5. Configure the backend pool to point to your Azure App Service.
6. Create a new routing rule to forward traffic to the backend pool.
7. Update your DNS settings to point to the Application Gateway.

I assume you have a Key Vault and know how to provide it with an SSL/TLS certificate. Let's combine the 2,3, 4, and 5 steps in a Bicep deployment.

### Deploy Application gateway using bicep

Let's deploy an Application Gateway with a backend pool pointing to an Azure App Service.

```bicep {linenos=table,file="main.bicep"}
```

### Configure DNS for Application Gateway

After deploying the Application Gateway, you need to update your DNS settings to point to the Application Gateway's public IP address. This ensures that all incoming traffic to your web application is routed through the Application Gateway, allowing it to provide the necessary security and performance enhancements.

{{< quoteblock >}}
:notebook: See also my other blog post on [Dual stack support with Application Gateway and IPv6](https://martdegraaf.github.io/blog/content/posts/application-gateway-ipv6/) for more details on updating DNS for dual stack support.
{{</ quoteblock >}}

## Detection vs Prevention mode

When configuring the WAF policy, you have the option to set the mode to either "Detection" or "Prevention". In Detection mode, the WAF will monitor and log potential threats without blocking any traffic. This is useful for testing and tuning the WAF rules before enforcing them. In Prevention mode, the WAF will actively block traffic that matches the defined rules, providing a higher level of security for your web applications.

I recommend starting with Detection mode to understand the traffic patterns and potential threats to your application. Once you are confident that the WAF rules are properly configured, you can switch to Prevention mode for enhanced protection.

See my next blog post on how to find false positives and tune your WAF rules.

## Next steps

We now got an Application gateway before your application. Your next steps could be:

- Configure custom WAF rules to tailor the security settings to your specific application needs.
- Set up monitoring and alerting to keep an eye on the WAF logs and performance metrics. ( see [WAF monitoring]({{< ref "monitor-your-waf/index.md" >}}))
- If you see no false positives you can switch from Detection to Prevention mode. (see [Troubleshoot Application Gateway in Production]({{< ref "troubleshoot-application-gateway-in-production/index.md" >}}))
- Implement ip restrictions for your Application gateway on Staging or acceptance environments. (see [Implement IP Restrictions]({{< ref "apply-ip-restrictions-application-firewall/index.md" >}}))
- Learn more about ipv6. (see [Application Gateway with IPv6 support]({{< ref "application-gateway-ipv6/index.md" >}})).
