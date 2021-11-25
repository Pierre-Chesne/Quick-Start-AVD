@description('Localisation de la region du \'resource group\'')
param location string = resourceGroup().location

@description('Nom du \'host pool\'')
param hostpools_name string

@description('Type de pool')
param poolType string

@description('Type de Load Balancer (BreadthFirst ou DepthFirst ou Persistent )\'')
@allowed([
  'BreadthFirst'
  'DepthFirst'
  'Persistent'
])
param lbType string

@description('Expiration de la cle d\'enregistrtement au format : yyyy-MM-ddTHH:mm:ss.fffffffZ exemple en PS: $((get-date).ToUniversalTime().AddHours(2).ToString(\'yyyy-MM-ddTHH:mm:ss.fffffffZ\'))')
param tokenExpirationTime string

@description('Nom du \'Workspace\'')
param workspaces_name string

@description('Nom du \'Desktop Application Group\'')
param dagname string

@description('Taille de la VM')
param vmSize string

@description('Nombre de VM')
param Numbers_of_VM int

@description('Nom du host pool')
param host_name_prefix string

@description('Nom administrateur local ')
param Username string

@description('Mot de passe de l\' administrateur local ')
@secure()
param pwdUser string

@description('Nom du domaine Active Directory ex: ma-pme.local ')
param domainName string

@description('Nom d\'un compte utilisateur ayant les droits d\'ajouter un compte d\'ordinateur ')
param domainUsername string

@description('Mot de passe utilisateur \'ex: pierrc@ma-pme.local\' ')
@secure()
param domainUsernamePassword string

@description('Nom du \'resource group\' du Vnet (joingnable avec controleur de domaine) ')
param virtualNetworkResourceGroupName string

@description('Nom du Vnet (joingnable avec controleur de domaine) ')
param virtualNetworkName string

@description('Nom du subnet (joingnable avec controleur de domaine) ')
param subnetName string

@description('ID de l\'abonnement')
param subscription_ID string

@description('Nom du ressource groupe de l\'image')
param RG_Images string

@description('Nom de l\'image')
param Image_WDV string

var subnet_id = resourceId(virtualNetworkResourceGroupName, 'Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)

resource hostpools_name_resource 'Microsoft.DesktopVirtualization/hostpools@2019-12-10-preview' = {
  name: hostpools_name
  location: location
  properties: {
    hostPoolType: poolType
    maxSessionLimit: 5
    loadBalancerType: lbType
    validationEnvironment: true
    registrationInfo: {
      registrationTokenOperation: 'Update'
      expirationTime: tokenExpirationTime
      token: 'null'
    }
  }
}

resource dagname_resource 'Microsoft.DesktopVirtualization/applicationgroups@2019-12-10-preview' = {
  name: dagname
  location: location
  kind: 'Desktop'
  properties: {
    hostPoolArmPath: hostpools_name_resource.id
    description: 'Desktop Application Group created through the Hostpool Wizard'
    friendlyName: 'Default Desktop'
    applicationGroupType: 'Desktop'
  }
}

resource workspaces_name_resource 'Microsoft.DesktopVirtualization/workspaces@2019-12-10-preview' = {
  name: workspaces_name
  location: location
  properties: {
    applicationGroupReferences: [
      resourceId('Microsoft.DesktopVirtualization/applicationgroups', '${hostpools_name}-DAG')
    ]
  }
  dependsOn: [
    resourceId('Microsoft.DesktopVirtualization/applicationgroups', '${hostpools_name}-DAG')
  ]
}

resource hostpools_name_AvSet 'Microsoft.Compute/availabilitySets@2019-07-01' = {
  name: '${hostpools_name}-AvSet'
  location: location
  sku: {
    name: 'Aligned'
  }
  properties: {
    platformFaultDomainCount: 2
    platformUpdateDomainCount: 5
  }
  dependsOn: [
    hostpools_name_resource
  ]
}

resource host_name_prefix_nic 'Microsoft.Network/networkInterfaces@2020-04-01' = [for i in range(0, Numbers_of_VM): {
  name: '${host_name_prefix}-${i}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnet_id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}]

resource host_name_prefix_resource 'Microsoft.Compute/virtualMachines@2019-07-01' = [for i in range(0, Numbers_of_VM): {
  name: '${host_name_prefix}-${i}'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        id: 'subscriptions/${subscription_ID}/resourceGroups/${RG_Images}/providers/Microsoft.Compute/images/${Image_WDV}'
      }
      osDisk: {
        osType: 'Windows'
        name: '${host_name_prefix}-${i}_OsDisk_1'
        createOption: 'FromImage'
        caching: 'ReadWrite'
      }
      dataDisks: []
    }
    osProfile: {
      computerName: '${host_name_prefix}-${i}'
      adminUsername: Username
      adminPassword: pwdUser
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', '${host_name_prefix}-${i}-nic')
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
    licenseType: 'Windows_Client'
    availabilitySet: {
      id: hostpools_name_AvSet.id
    }
  }
  dependsOn: [
    resourceId('Microsoft.Network/networkInterfaces', '${host_name_prefix}-${i}-nic')
    hostpools_name_resource
    hostpools_name_AvSet
  ]
}]

resource host_name_prefix_joindomain 'Microsoft.Compute/virtualMachines/extensions@2018-10-01' = [for i in range(0, Numbers_of_VM): {
  name: '${host_name_prefix}-${i}/joindomain'
  location: location
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
  dependsOn: [
    resourceId('Microsoft.Compute/virtualMachines', '${host_name_prefix}-${i}')
    hostpools_name_resource
  ]
}]

resource host_name_prefix_dscextension 'Microsoft.Compute/virtualMachines/extensions@2018-10-01' = [for i in range(0, Numbers_of_VM): {
  name: '${host_name_prefix}-${i}/dscextension'
  location: location
  properties: {
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.73'
    autoUpgradeMinorVersion: true
    settings: {
      modulesUrl: 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/ARM-wvd-templates/DSC/Configuration.zip'
      configurationFunction: 'Configuration.ps1\\AddSessionHost'
      properties: {
        hostPoolName: '${host_name_prefix}-${i}'
        registrationInfoToken: hostpools_name_resource.properties.registrationInfo.token
      }
    }
  }
  dependsOn: [
    resourceId('Microsoft.Compute/virtualMachines', '${host_name_prefix}-${i}')
    hostpools_name_resource
  ]
}]