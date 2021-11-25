param nic string = 'nic'

param virtualNetworkResourceGroupName string = 'RG-ID-PROD'
param subnetName string = 'Subnet-Hosts'
param virtualNetworkName string = 'Vnet-ID-PROD'

var subnet_id = resourceId(virtualNetworkResourceGroupName, 'Microsoft.Network/virtualNetworks/subnets',virtualNetworkName,subnetName)

resource nicX 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: nic
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnet_id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}
