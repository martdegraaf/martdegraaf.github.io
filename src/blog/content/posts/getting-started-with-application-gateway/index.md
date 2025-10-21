---
title: "Getting Started With Application Gateway"
slug: "getting-started-with-application-gateway"
date: 2025-10-17T14:16:30+02:00
publishdate: 2025-10-17T14:16:30+02:00
draft: true
author: ["Mart de Graaf"]
tags: []
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
2. Create a Public IP Address for the Application Gateway.
3. Create a new Application Gateway with WAF enabled.
4. Configure the backend pool to point to your Azure App Service.
5. Create a new routing rule to forward traffic to the backend pool.
6. Update your DNS settings to point to the Application Gateway.

I assume you have a Key Vault and know how to provide it with an SSL/TLS certificate. Let's combine the 2,3, 4, and 5 steps in a Bicep deployment.

## Bicep code
Let's deploy an Application Gateway with a backend pool pointing to an Azure App Service.

```bicep {linenos=table}
param location string = resourceGroup().location
param region string
param environment string

module keyvault 'br/public:avm/res/security/keyvault:0.9.0' = {
  name: '${deployment().name}-kv'
  scope: resourceGroup()
  params: {
    name: 'kv-${region}-${environment}'
    // Other parameters...
  }
}

module wafPolicy 'br/public:avm/res/network/application-gateway-web-application-firewall-policy:<version>' = {
  name: 'applicationGatewayWebApplicationFirewallPolicyDeployment'
  params: {
    // Required parameters
    managedRules: {
      managedRuleSets: [
        {
          ruleGroupOverrides: []
          ruleSetType: 'OWASP'
          ruleSetVersion: '3.2'
        }
        {
          ruleSetType: 'Microsoft_BotManagerRuleSet'
          ruleSetVersion: '0.1'
        }
      ]
    }
    name: 'mycoolwaf'
    // Non-required parameters
    location: location
    policySettings: {
      fileUploadLimitInMb: 10
      jsChallengeCookieExpirationInMins: 60
      mode: 'Detection' // 'Detection' or 'Prevention'
      state: 'Enabled'
    }
  }
}

module publicIp 'br/public:avm/res/network/public-ip-address:0.6.0' = {
  name: '${deployment().name}-pip'
  scope: resourceGroup()
  params: {
    name: 'pip-ag-${region}-${environment}'
    // Other parameters...
  }
}

module appGateway 'br/public:avm/res/network/application-gateway:0.7.1' = {
  name: '${deployment().name}-agw'
  scope: resourceGroup()
  params: {
    name: 'ag-${region}-${environment}'
    sku: 'WAF_v2'
    frontendIpConfigurations: [
        {
            name: 'appGwFrontend'
            properties: {
                publicIPAddress: {
                    id: publicIp.id
                }
                privateAllocationMethod: 'Dynamic'
            }
        }
        // Add IPv6 frontend configuration if needed, see my other blog post
    ]
    firewallPolicyResourceId: wafPolicy.outputs.resourceId
    backendAddressPools: [
        {
            name: 'appGwBackendPool'
            properties: {
                backendAddresses: [
                    {
                        fqdn: 'your-app-service.azurewebsites.net'
                    }
                ]
            }
        }
    ]
    httpListeners: [
        {
            name: 'appGwHttpListener'
            properties: {
                frontendIpConfiguration: {
                    id: '${module.appGateway.id}/frontendIpConfigurations/appGwFrontend'
                }
                frontendPort: {
                    id: '${module.appGateway.id}/frontendPorts/appGwFrontendPort'
                }
                protocol: 'Http'
            }
        }
    ]
    requestRoutingRules: [
        {
            name: 'appGwRoutingRule'
            properties: {
                httpListener: {
                    id: '${module.appGateway.id}/httpListeners/appGwHttpListener'
                }
                backendAddressPool: {
                    id: '${module.appGateway.id}/backendAddressPools/appGwBackendPool'
                }
                backendHttpSettings: {
                    id: '${module.appGateway.id}/backendHttpSettings/appGwBackendHttpSettings'
                }
            }
        }
    ]
  }
}
```

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