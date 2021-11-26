param numbersOfVm int = 2
param hostNamePrefix string = 'Host-AVD'
param vmSize string = 'Standard D2s v3'

param galleryName string = 'aibsig00001'
param galleryImageDefinitionName string = 'win10avdoct'
param galleryImageVersionName string = '0.24956.1975'

param userNameLocal string = 'pierrc'
param pwdLocal string = 'Password123$'

resource hosts 'Microsoft.Compute/virtualMachines@2021-07-01' = [for i in range(0, numbersOfVm): {
  name: '${hostNamePrefix}-${i}'
  location: resourceGroup().location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        sharedGalleryImageId: resourceId('Microsoft.Compute/galleries/images/versions', galleryName, galleryImageDefinitionName, galleryImageVersionName)
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
