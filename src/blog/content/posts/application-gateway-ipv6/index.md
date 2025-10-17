---
title: "Application Gateway Ipv6"
slug: "application-gateway-ipv6"
date: 2025-10-17T10:55:50+02:00
publishdate: 2025-10-17T10:55:50+02:00
draft: true
author: ["Mart de Graaf"]
tags: ["application-gateway", "ipv6", "azure", "WAF"]
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

Dutch governments need to be available over IPv6 according to [this mandate](https://www.forumstandaardisatie.nl/ipv6/). Therefore I had to make sure my Application Gateway with Web Application Firewall (WAF) is also available over IPv6. In this blog I will explain some of the challenges we faced and how we solved them.

# System context

In the existing system we have multiple apps running on Azure App Services behind an Application Gateway with WAF. The Application Gateway is currently only available over IPv4.

We have a listener and rule in place for each app. Each app is configured with its own FQDN (Fully Qualified Domain Name) and a TLS/SSL certificate is used for secure communication.

The system was geo redundant with two Application Gateways in different regions, each with its own public IP address.

A traffic manager profile is used to distribute traffic between the two Application Gateways based on priority. A common Active passive setup.

## Dual band

To make the Application Gateway available over IPv6, we needed to configure dual stack support. This means you have to **redeploy** the Application Gateway. This has a massive impact because of our current strategy with multiple listeners and rules. We had to make sure that all configurations were preserved during the redeployment.

If you need to do this i recommend:

1. Use an AVM module to build your new Application Gateway with dual stack support.
2. Reconsider if you need zones for your Application Gateway. Those also require a full redeployment.

## Traffic Manager

We had a traffic manager profile in place to distribute traffic between the two Application Gateways. The traffic manager profile also needed to be updated to support IPv6.

This was actually really complex because Traffic Manager does not support dual stack endpoints directly. Therefore we had to create separate endpoints for IPv4 and IPv6 in the traffic manager profile.

Thereby the Traffic manager routing method priority only supports one endpoint per target. So we had to create three traffic manager profiles to achieve the desired failover behavior. One with the routing method priority with two external endpoints pointing to the nested traffic manager profiles. Each nested traffic manager profile with routing method 'MultiValue' had one endpoint for IPv4 and one for IPv6.


__System explained__
```cs {linenos=table}
__insert code here__
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
