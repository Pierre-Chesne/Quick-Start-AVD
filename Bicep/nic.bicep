param nic string = 'nic'
param subnetName string = 'Subnet-Hosts'
param vnetName string = 'Vnet-ID-PROD'

//var subnet_id = resourceId(vnetName, 'Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)

resource nicX 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: nic
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: '/subscriptions/45d70f51-2e63-4daa-8870-27e468ba9baa/resourceGroups/RG-ID-PROD/providers/Microsoft.Network/virtualNetworks/Vnet-ID-PROD/Subnet-Hosts'
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
