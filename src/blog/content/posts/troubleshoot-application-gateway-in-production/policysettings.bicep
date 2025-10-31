resource applicationGatewayWAFPolicy 'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies@2024-10-01' = {
  name: 'WafPolicy'
  location: 'West Europe'
  properties: {
    managedRules: {
      managedRuleSets: [
        //trimmed
      ]
    }
    policySettings: {
      customBlockResponseStatusCode: 418
      customBlockResponseBody: base64('Oops! Your request was blocked by the WAF. But don\'t worry, I\'m just a teapot!')
      mode: 'Prevention'
    }
  }
}
