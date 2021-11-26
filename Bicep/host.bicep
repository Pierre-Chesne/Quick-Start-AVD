param numbersOfVm int = 2
param hostNamePrefix string = 'Host-AVD'
param vmSize string = 'Standard_D2s_v3'

param galleryNameResourceGroupName string = 'Rg-AVD-Images-00001'
param galleryName string = 'aibsig00001'
param galleryImageDefinitionName string = 'win10avdoct'
param galleryImageVersionName string = 'latest'

param userNameLocal string = 'pierrc'
param pwdLocal string = '*******'

resource hosts 'Microsoft.Compute/virtualMachines@2021-07-01' = [for i in range(0, numbersOfVm): {
  name: '${hostNamePrefix}-${i}'
  location: resourceGroup().location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        sharedGalleryImageId: resourceId(galleryNameResourceGroupName,'Microsoft.Compute/galleries/images/versions', galleryName, galleryImageDefinitionName, galleryImageVersionName)
                 
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
