param numbersOfVm int
param hostNamePrefix string
param hostpool0Reg string

resource dscAgentsAVD 'Microsoft.Compute/virtualMachines/extensions@2021-07-01' = [for i in range(0, numbersOfVm): {
  name: '${hostNamePrefix}-${i}/dscextension'
  location: resourceGroup().location
  properties: {
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.73'
    autoUpgradeMinorVersion: true
    settings: {
      modulesUrl: 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/ARM-wvd-templates/DSC/Configuration.zip'
      configurationFunction: 'Configuration.ps1\\AddSessionHost'
      properties: {
        hostPoolName: '${hostNamePrefix}-${i}'
        registrationInfoToken: hostpool0Reg
        
      }
    }
  }  
}]
