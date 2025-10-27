
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
