resource applicationGatewayWAFPolicy 'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies@2024-10-01' = {
  name: 'WafPolicy'
  location: 'West Europe'
  tags: {
    Environment: 'Dev'
    'hidden-title': 'Smart Web Application Firewall'
  }
  properties: {
    managedRules: {
      managedRuleSets: [
        {
          ruleGroupOverrides: []
          ruleSetType: 'OWASP'
          ruleSetVersion: '3.2'
        }
        {
          ruleGroupOverrides: []
          ruleSetType: 'Microsoft_BotManagerRuleSet'
          ruleSetVersion: '0.1'
        }
      ]
      exclusions: [
        {
          exclusionManagedRuleSets: [
            {
              ruleSetType: 'OWASP'
              ruleSetVersion: '3.2'
              ruleGroups: [
                {
                  ruleGroupName: 'REQUEST-942-APPLICATION-ATTACK-SQLI'
                  rules: [
                    {
                      ruleId: '942430'
                    }
                  ]
                }
              ]
            }
          ]
          matchVariable: 'RequestArgNames'
          selector: 'naam'
          selectorMatchOperator: 'Contains'
        }
        {
          exclusionManagedRuleSets: [
            {
              ruleGroups: [
                {
                  ruleGroupName: 'REQUEST-942-APPLICATION-ATTACK-SQLI'
                  rules: [
                    {
                      ruleId: '942450'
                    }
                  ]
                }
                {
                  ruleGroupName: 'REQUEST-932-APPLICATION-ATTACK-RCE'
                  rules: [
                    {
                      ruleId: '932150'
                    }
                  ]
                }
              ]
              ruleSetType: 'OWASP'
              ruleSetVersion: '3.2'
            }
          ]
          matchVariable: 'RequestCookieNames'
          selector: 'ai_session'
          selectorMatchOperator: 'StartsWith'
        }
      ]
    }
    customRules: []
    policySettings: {
      mode: 'Prevention' // 'Detection' or 'Prevention'
      state: 'Enabled'
    }
  }
}
