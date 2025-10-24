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
