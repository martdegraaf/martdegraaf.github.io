---
title: "Use IPV6 in Azure behind the Application Gateway"
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

```bicep {linenos=table}
module appGateway 'br/public:avm/res/network/application-gateway:0.7.1' = {
  name: '${deployment().name}-agw'
  scope: resourceGroup()
  params: {
    name: 'ag-${applicationGatewaySequence}-${region}-${environment}'
    sku: 'WAF_v2'
    availabilityZones: [1,2,3] //TODO: Remove this line if you don't need zones
    frontendIpConfigurations: [
        {
            name: 'appGwFrontendIPv4'
            properties: {
                publicIPAddress: {
                    id: publicIpV4.id
                }
                privateAllocationMethod: 'Dynamic'
            }
        }
        {
            name: 'appGwFrontendIPv6'
            properties: {
                publicIPAddress: {
                    id: publicIpV6.id
                }
                privateAllocationMethod: 'Dynamic'
            }
        }
    ]
    // Other parameters...
  }
}
```

See https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/application-gateway for more details.

## Traffic Manager

We had a traffic manager profile in place to distribute traffic between the two Application Gateways. The traffic manager profile also needed to be updated to support IPv6.

This was actually really complex because Traffic Manager does not support dual stack endpoints directly. Therefore we had to create separate endpoints for IPv4 and IPv6 in the traffic manager profile.

Thereby the Traffic manager routing method priority only supports one endpoint per target. So we had to create three traffic manager profiles to achieve the desired failover behavior. One with the routing method priority with two external endpoints pointing to the nested traffic manager profiles. Each nested traffic manager profile with routing method 'MultiValue' had one endpoint for IPv4 and one for IPv6.

// IMG Traffic Manager setup
### Serve traffic over IPv4 and IPv6

Because we want to serve traffic over both IPv4 and IPv6, we had to create a traffic manager profile with the routing method 'MultiValue'. This profile contains two external endpoints, one for the IPv4 address and one for the IPv6 address of the Application Gateway.

```bicep {linenos=table}
param region string
param environment string
param applicationGatewaySequence string

resource publicIpV4 'Microsoft.Network/publicIPAddresses@2023-11-01' existing = {
  name: 'pip-ag-${applicationGatewaySequence}-${region}-${environment}-v4'
}

resource publicIpV6 'Microsoft.Network/publicIPAddresses@2023-11-01' existing = {
  name: 'pip-ag-${applicationGatewaySequence}-${region}-${environment}-v6'
}

module agTrafficManager 'br/public:avm/res/network/trafficmanagerprofile:0.3.0' = {
  name: '${deployment().name}-tm'
  scope: resourceGroup()
  params: {
    name: 'tm-ag-${applicationGatewaySequence}-${region}-${environment}'
    ttl: 15
    trafficRoutingMethod: 'MultiValue'  
    maxReturn: 2
    endpoints: [
      {
        name: 'ag-${applicationGatewaySequence}-${region}-${environment}-v4'
        type: 'Microsoft.Network/trafficManagerProfiles/externalEndpoints'
        properties: {
            target: publicIpV4.properties.ipAddress
            endpointStatus: 'Enabled'
            endpointMonitorStatus: 'Unmonitored'
            alwaysServe: 'Enabled'
        }
      }
      {
        name: 'ag-${applicationGatewaySequence}-${region}-${environment}-v6'
        type: 'Microsoft.Network/trafficManagerProfiles/externalEndpoints'
        properties: {
            target: publicIpV6.properties.ipAddress
            endpointStatus: 'Enabled'
            endpointMonitorStatus: 'Unmonitored'
            alwaysServe: 'Enabled'
        }
      }
    ]
  }
}
```

### Parent profile for failover

To achieve failover between the two Application Gateways in different regions, we created a parent traffic manager profile with the routing method 'Priority'. This profile contains two external endpoints, each pointing to one of the nested traffic manager profiles.

There are three different endpoint types in Traffic Manager:
1. Azure endpoints
2. External endpoints
3. Nested endpoints

I first tried to use nested endpoints, but that did not work with the health probes. Therefore we used external endpoints pointing to the FQDN of the nested traffic manager profiles. I could make 3 traffic managers per application. We actually thought that was a good idea, until we hit the limit of Traffic Manager profiles per subscription (200).

// TODO CONCLUSIE EXTERNAL

```bicep {linenos=table}
param region string
param environment string
param primaryRegion string
param secondaryRegion string
param applicationGatewaySequence string

module serviceTrafficManagerFailover 'br/public:avm/res/network/trafficmanagerprofile:0.3.0' = {
  name: '${deployment().name}-tm-failover'
  scope: resourceGroup()
  params: {
    name: 'tm-ag-failover-${applicationGatewaySequence}-${environment}'
    ttl: 15
    trafficRoutingMethod: 'Priority'
    monitorConfig: {
        protocol: 'HTTPS'
        port: 443
        path: '/healthcheck' //TODO: Adjust based on your health probe requirements
        intervalInSeconds: 30
        timeoutInSeconds: 10
        toleratedNumberOfFailures: 3
        customHeaders: [
            {
                name: 'Host'
                value: 'someapi.martdegraaf.nl' //TODO: Adjust based on your health probe requirements
            }
        ]
    }
    endpoints: [
      {
        name: 'tm-${primaryRegion}-${environment}'
        type: 'Microsoft.Network/trafficManagerProfiles/externalEndpoints'
        properties: {
            target: 'tm-ag-${applicationGatewaySequence}-${primaryRegion}-${environment}.trafficmanager.net'
            endpointStatus: 'Enabled'
            priority: 1
        }
      }
      {
        name: 'tm-${secondaryRegion}-${environment}'
        type: 'Microsoft.Network/trafficManagerProfiles/externalEndpoints'
        properties: {
            target: 'tm-ag-${applicationGatewaySequence}-${secondaryRegion}-${environment}.trafficmanager.net'
            endpointStatus: 'Enabled'
            priority: 2
        }
      }
    ]
  }
}
```

# Conclusion and discussion
__Solution explained__
```cs {linenos=table}
__insert code here__
```
