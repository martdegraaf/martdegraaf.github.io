@export()
type restrictedDomain = {
  name: string
  allowedIPs: array
  url: string
}

param location string = resourceGroup().location
param tags object = resourceGroup().tags

param defaultAllowedIPs array = [
  '127.0.0.1' // Your company IP
]
param restrictedDomains restrictedDomain[] = []

resource WebApplicationFirewallPolicies 'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies@2023-11-01' = {
  name: 'WafPolicy'
  location: location
  tags: tags
  properties: {
    customRules: [
      for (item, index) in restrictedDomains: {
        name: '${item.name}ipBlock'
        priority: index
        ruleType: 'MatchRule'
        action: 'Block'
        matchConditions: [
          {
            matchVariables: [
              {
                variableName: 'RequestHeaders'
                selector: 'Host'
              }
            ]
            matchValues: [
              item.url
            ]
            operator: 'BeginsWith'
            transforms: [
              'Lowercase'
            ]
            negationConditon: false
          }
          {
            matchVariables: [
              {
                variableName: 'RemoteAddr'
              }
            ]
            matchValues: union(defaultAllowedIPs, item.allowedIPs)
            operator: 'IPMatch'
            negationConditon: true
          }
        ]
      }
    ]
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: 'OWASP'
          ruleSetVersion: '3.0'
          ruleGroupOverrides: [
            {
              ruleGroupName: 'REQUEST-920-PROTOCOL-ENFORCEMENT'
              rules: [
                {
                  ruleId: '920350'
                  action: 'Block'
                }
              ]
            }
          ]
        }
      ]
    }
  }
}
