//https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules#path-to-a-module

module smartkeysKeyvault 'ts/' = {
  name: 'smartkeys'
  params: {
    name: 'smartkeys'
  }
}
