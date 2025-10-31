param location string = resourceGroup().location
param region string
param environment string
param tags object

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'vnet-${region}-${environment}'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-agw'
        properties: {
          addressPrefix: '10.0.1.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
      }
      { // Sample for if your backends are in Azure Container apps
        name: 'snet-containerapp'
        properties: {
          addressPrefix: '10.0.2.0/23'
          delegations: [
            {
              name: 'Microsoft.App/environments'
              properties: {
                serviceName: 'Microsoft.App/environments'
              }
            }
          ]
        }
      }
    ]
  }
}

module keyvault 'br/public:avm/res/key-vault/vault:0.13.3' = {
  name: '${deployment().name}-kv'
  scope: resourceGroup()
  params: {
    name: 'kv-${region}-${environment}'
    // Other parameters...
  }
}

module wafPolicy 'br/public:avm/res/network/application-gateway-web-application-firewall-policy:0.2.0' = {
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

var gatewayId = resourceId('Microsoft.Network/applicationGateways/probes', 'ag-${region}-${environment}')
module appGateway 'br/public:avm/res/network/application-gateway:0.7.1' = {
  name: '${deployment().name}-agw'
  scope: resourceGroup()
  params: {
    name: 'ag-${region}-${environment}'
    sku: 'WAF_v2'
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: virtualNetwork.properties.subnets[0].id
          }
        }
      }
    ]
    frontendIPConfigurations: [
        {
            name: 'appGwFrontend'
            properties: {
                publicIPAddress: {
                    id: publicIp.outputs.resourceId
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
                    id: '${gatewayId}/frontendIpConfigurations/appGwFrontend'
                }
                frontendPort: {
                    id: '${gatewayId}/frontendPorts/appGwFrontendPort'
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
                    id: '${gatewayId}/httpListeners/appGwHttpListener'
                }
                backendAddressPool: {
                    id: '${gatewayId}/backendAddressPools/appGwBackendPool'
                }
                backendHttpSettings: {
                    id: '${gatewayId}/backendHttpSettings/appGwBackendHttpSettings'
                }
            }
        }
    ]
  }
}
