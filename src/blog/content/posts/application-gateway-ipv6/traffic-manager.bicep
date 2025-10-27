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
