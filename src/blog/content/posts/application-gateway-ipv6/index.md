---
title: "Use IPV6 in Azure with the Application Gateway"
slug: "application-gateway-ipv6"
date: 2025-10-17T10:55:50+02:00
publishdate: 2025-10-17T10:55:50+02:00
draft: true
author: ["Mart de Graaf"]
tags: ["application-gateway", "ipv6", "azure", "WAF"]
summary: "Learn how to configure an Azure Application Gateway to support IPv6 in Azure."
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
    alt: "Street in Lisbon, building trust" # alt text
    caption: "Do you build trust?" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

Dutch governments need to be available over IPv6 according to [this mandate](https://www.forumstandaardisatie.nl/ipv6/). Therefore I had to make sure my Application Gateway with Web Application Firewall (WAF) is also available over IPv6. In this blog I will explain some of the challenges we faced and how we solved them.

## System context

In the existing system we have multiple apps running on Azure App Services behind an Application Gateway with WAF. The Application Gateway is currently only available over IPv4.

We have a listener and rule in place for each app. Each app is configured with its own FQDN (Fully Qualified Domain Name) and a TLS/SSL certificate is used for secure communication.

The system was geo redundant with two Application Gateways in different regions, each with its own public IP address.

A traffic manager profile is used to distribute traffic between the two Application Gateways based on priority. A common Active passive setup.

![Architecture v1 - Application gateway behind an Traffic Manager](appgateway.drawio.svg#center "Architecture v1 - Application gateway behind an Traffic Manager")

## Dual stack

To make the Application Gateway available over IPv6, we needed to configure dual stack support. This means you have to **redeploy** the Application Gateway. This has a massive impact because of our current strategy with multiple listeners and rules. We had to make sure that all configurations were preserved during the redeployment.

If you need to do this i recommend:

1. Add Ipv6 address prefixes to your virtual network.
2. Use an AVM module to build your new Application Gateway with dual stack support.
3. Reconsider if you need zones for your Application Gateway. Those also require a full redeployment.

```bicep {linenos=table,file="application-gateway-ipv6.bicep"}
```

{{< quoteblock >}}
:robot: In the example 'Azure Verified Modules' are used, see the documentation of these components here:
- https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/application-gateway
- https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/application-gateway-web-application-firewall-policy
{{</ quoteblock >}}

### public ip addresses connected

Let's take a look what this means for our architecture. For each Application Gateway we have now two public ip addresses. We just need to configure that the DNS can find this new IPV6 address.

![Architecture v2 - added IPV6 support](appgateway-dualstack.drawio.svg#center "Architecture v2 - Added Public ip addresses for IPV6")

## Traffic Manager

We had a traffic manager profile in place to distribute traffic between the two Application Gateways. The traffic manager profile also needed to be updated to support IPv6.

This was actually really complex because Traffic Manager does not support dual stack endpoints directly. Therefore we had to create separate endpoints for IPv4 and IPv6 in the traffic manager profile.

Thereby the Traffic manager routing method priority only supports one endpoint per target. So we had to create three traffic manager profiles to achieve the desired failover behavior. One with the routing method priority with two external endpoints pointing to the nested traffic manager profiles. Each nested traffic manager profile with routing method 'MultiValue' had one endpoint for IPv4 and one for IPv6.

### Serve traffic over IPv4 and IPv6

Because we want to serve traffic over both IPv4 and IPv6, we had to create a traffic manager profile with the routing method 'MultiValue'. This profile contains two external endpoints, one for the IPv4 address and one for the IPv6 address of the Application Gateway.

![Architecture v3 - added trafficmanager with MultiValue support](appgateway-dualstack-nested.drawio.svg#center "Architecture v3 - Added trafficmanager with MultiValue support")

This can be achieved with the following Bicep code:

```bicep {linenos=table,file="traffic-manager.bicep"}
```

### Parent profile for failover

To achieve failover between the two Application Gateways in different regions, we created a parent traffic manager profile with the routing method 'Priority'. This profile contains two external endpoints, each pointing to one of the nested traffic manager profiles.

There are three different endpoint types in Traffic Manager:

1. Azure endpoints
2. External endpoints
3. Nested endpoints

I initially attempted to use nested endpoints, but they were incompatible with the health probes. This could be fixed by creating a nested traffic manager profile for each application instead of per Application Gateway. This approach allowed us to create three Traffic Manager profiles per application, which seemed like a good solution until we encountered the subscription limit of 200 Traffic Manager profiles.

As a result, we switched to using external endpoints that pointed to the FQDNs of the nested Traffic Manager profiles. This allowed us to stay within the subscription limits while still achieving the desired failover behavior.

```bicep {linenos=table,file="ag-ipv6.bicep"}
```

## Update DNS records

If you are using a Traffic Manager profile to expose your application gateway you can update your CNAME record to point to the Traffic Manager FQDN. This way both IPv4 and IPv6 traffic will be routed correctly.

If you are routing directly to the Application Gateway you will need to update both the A record (IPv4) and the AAAA record (IPv6) in your DNS settings to point to the respective IP addresses of the Application Gateway.

After updating the DNS records, it may take some time for the changes to propagate. You can use tools like `nslookup` or online DNS checkers to verify that the records have been updated correctly.

```cmd
nslookup yourapp.yourdomain.com
```

## Conclusion and discussion

It has consequences to enable IPv6 on your Application Gateway. You have to redeploy the Application Gateway which can be complex depending on your current setup. Also for every listener you will need two listeners (one for IPv4 and one for IPv6). The limit of active listeners is 100 so keep that in mind for your architecture. with two listeners for each application you can only have 50 applications behind one Application Gateway.

Now you have dual stack support. Your Application Gateway is available over both IPv4 and IPv6. Make sure to test your setup thoroughly to ensure that everything is working as expected.

## Further reading

- [Microsoft Docs: Configure an Application Gateway to use IPv6](https://learn.microsoft.com/en-us/azure/application-gateway/ipv6-application-gateway-portal)
