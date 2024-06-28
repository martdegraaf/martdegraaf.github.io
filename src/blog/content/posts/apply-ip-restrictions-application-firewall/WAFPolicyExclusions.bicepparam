using './WAFPolicyExclusions.bicep'

param defaultAllowedIPs = [
  '127.0.0.1' // Your company IP
]
param restrictedDomains = [
  {
    name: 'MartService'
    url: 'mart.contoso.com'
    allowedIPs: []
  }
  {
    name: 'SMartService'
    url: 'smart.contoso.com'
    allowedIPs: [
      '0.0.0.0' // Someone who needs access
    ]
  }
]

