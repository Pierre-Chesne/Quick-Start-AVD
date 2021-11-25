param numbersOfVm int
param nic string

param virtualNetworkResourceGroupName string
param subnetName string
param virtualNetworkName string

var subnet_id = resourceId(virtualNetworkResourceGroupName, 'Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)

resource nicX 'Microsoft.Network/networkInterfaces@2021-03-01' = [for i in range(0, numbersOfVm): {
  name: '${nic}-${i}-nic'
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
}]
