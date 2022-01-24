param numbersOfVm int
param hostNamePrefix string
param vmSize string

param galleryNameResourceGroupName string
param galleryName string
param galleryImageDefinitionName string
param galleryImageVersionName string

param userNameLocal string
param pwdLocal string

resource hosts 'Microsoft.Compute/virtualMachines@2021-07-01' = [for i in range(0, numbersOfVm): {
  name: '${hostNamePrefix}-${i}'
  location: resourceGroup().location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {       
        id: resourceId(galleryNameResourceGroupName,'Microsoft.Compute/galleries/images/versions', galleryName, galleryImageDefinitionName, galleryImageVersionName)                 
      }
      osDisk: {
        osType: 'Windows'
        name: '${hostNamePrefix}-${i}_OsDisk'
        createOption: 'FromImage'
        caching: 'ReadWrite'        
      }
      dataDisks: []
    }
    osProfile: {
      computerName: '${hostNamePrefix}-${i}'
      adminUsername: userNameLocal
      adminPassword: pwdLocal
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
      }      
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', '${hostNamePrefix}-${i}-nic')
        }
      ]      
    }
    licenseType: 'Windows_Client'
  }  
}]
