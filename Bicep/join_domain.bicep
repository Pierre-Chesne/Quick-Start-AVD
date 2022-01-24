param numbersOfVm int
param hostNamePrefix string
param domainName string
param domainUsername string
param domainUsernamePassword string


resource joinDomainX 'Microsoft.Compute/virtualMachines/extensions@2021-07-01' = [for i in range(0, numbersOfVm): {
  name: '${hostNamePrefix}-${i}/joindomain'
  location: resourceGroup().location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: '1.3'
    autoUpgradeMinorVersion: true
    settings: {
      name: domainName
      user: domainUsername
      restart: 'true'
      options: '3'
    }
    protectedSettings: {
      password: domainUsernamePassword
    }
  }  
}]
