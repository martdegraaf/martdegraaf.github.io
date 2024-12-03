//https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules#path-to-a-module

module smartkeysKeyvault 'br/public:avm/res/key-vault/vault:0.9.0' = {
  name: 'smartkeys'
  params: {
    name: 'smartkeys'
  }
}
