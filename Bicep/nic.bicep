param nic string = 'nic'
param subnetName string = 'Subnet-Hosts'
param vnetName string = 'Vnet-ID-PROD'

var subnet_id = resourceId(vnetName, 'Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)

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
