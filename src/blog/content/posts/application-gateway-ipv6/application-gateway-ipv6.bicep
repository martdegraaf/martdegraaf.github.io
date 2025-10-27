param region string
param environment string
param applicationGatewayNr int

module vnet 'br/public:avm/res/network/virtual-network:0.7.1' = {
  params: {
    name: 'ag-vnet'
    addressPrefixes: [
      '10.0.0.0/16' // IPv4 address prefix
      'fd00::/48' // IPv6 address prefix
    ]
    subnets: [
      {
        name: 'appgw-subnet'
        addressPrefixes: [
          '10.0.1.0/24' // IPv4 subnet for Application Gateway
          'fd00:0:0:1::/64' // IPv6 subnet for Application Gateway
        ]
        delegation: 'Microsoft.Network/applicationGateways'
      }
    ]
  }
}

module publicIpV4 'br/public:avm/res/network/public-ip-address:0.9.0' = {
  params: {
    // Required parameters
    name: 'pip-v4-mart'
    // Non-required parameters
    availabilityZones: [1, 2, 3]
    publicIPAddressVersion: 'IPv6'
    publicIPAllocationMethod: 'Static'
  }
}

module publicIpV6 'br/public:avm/res/network/public-ip-address:0.9.0' = {
  params: {
    // Required parameters
    name: 'pip-v6-mart'
    // Non-required parameters
    availabilityZones: [1, 2, 3]
    publicIPAddressVersion: 'IPv6'
    publicIPAllocationMethod: 'Static'
  }
}
var agName = 'ag-${applicationGatewayNr}-${region}-${environment}'
module appGateway 'br/public:avm/res/network/application-gateway:0.7.1' = {
  name: '${deployment().name}-agw'
  scope: resourceGroup()
  params: {
    name: agName
    sku: 'WAF_v2'
    availabilityZones: [1, 2, 3] //TODO: Remove this line if you don't need zones
    gatewayIPConfigurations: [
      {
        name: 'agconfig'
        properties: {
          subnet: {
            id: vnet.outputs.subnetResourceIds[0]
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGwFrontendIPv4'
        properties: {
          publicIPAddress: {
            id: publicIpV4.outputs.resourceId
          }
          privateAllocationMethod: 'Dynamic'
        }
      }
      {
        name: 'appGwFrontendIPv6'
        properties: {
          publicIPAddress: {
            id: publicIpV6.outputs.resourceId
          }
          privateAllocationMethod: 'Dynamic'
        }
      }
    ]
    listeners: [
      {
        name: 'mart-listener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId(
              'Microsoft.Network/applicationGateways/frontendIPConfigurations',
              agName,
              'appGwFrontendIPv6'
            )
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', agName, 'port_443')
          }
          protocol: 'Https'
          hostname: 'tm.martdegraaf.nl'
          sslCertificate: {
            id: resourceId('Microsoft.Network/applicationGateways/sslCertificates', agName, 'sslCert')
          }
        }
      }
    ]
    routingRules: [
      {
        name: 'route-ipv6'
        properties: {
          ruleType: 'Basic'
          priority: 1
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', agName, 'mart-listener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', agName, 'mart-backendpool')
          }
          backendHttpSettings: {
            id: resourceId(
              'Microsoft.Network/applicationGateways/backendHttpSettingsCollection',
              agName,
              'mart-backendSetting'
            )
          }
        }
      }
    ]
  }
}
