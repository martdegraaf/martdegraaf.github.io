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
