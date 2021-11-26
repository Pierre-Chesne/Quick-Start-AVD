targetScope = 'subscription'

param location string
param rgName string
param tokenExpirationTime string
param hostPoolName string
param hostPoolType string
param loadBalancerType string
param maxSessionLimit int
param validationEnvironment bool
param applicationGroupType string
param dagName string
param workspaceName string
param numbersOfVm int
param hostName string
param virtualNetworkResourceGroupName string
param virtualNetworkName string
param subnetName string

module rgModule 'rg.bicep' = {
  name: 'deployRgModule'  
  params: {
    location: location
    rgName: rgName 
  }
}

module hostPool0 'hostpools.bicep' = {
  scope: resourceGroup(rgName)
  name: 'deployHostPool'
  params: {
    tokenExpirationTime: tokenExpirationTime
    hostPoolName: hostPoolName
    hostPoolType: hostPoolType
    loadBalancerType: loadBalancerType
    maxSessionLimit: maxSessionLimit
    validationEnvironment: validationEnvironment
  }
  dependsOn: [
    rgModule
  ]
}

module desktopApplicationGroup 'application_group.bicep' = {
  scope: resourceGroup(rgName)
  name: 'deploydesktopApplicationGroup'
  params: {
    applicationGroupType: applicationGroupType
    dagName: dagName
    hostPoolArmPath: hostPool0.outputs.hostPool0  
  }
}

module workspace 'workspaces.bicep' = {
  scope: resourceGroup(rgName)
  name: 'deployWorkspace'
  params: {
    applicationGroupReferences: desktopApplicationGroup.outputs.applicationGroup0
    workspaceName: workspaceName
  }
}

module nicX 'nic.bicep' = {
  scope: resourceGroup(rgName)
  name: 'deployNic'
  params: {
    hostName: hostName    
    numbersOfVm: numbersOfVm
    virtualNetworkResourceGroupName: virtualNetworkResourceGroupName
    virtualNetworkName: virtualNetworkName
    subnetName: subnetName
  }
  dependsOn: [
    rgModule
  ]
}

module hostX 'host.bicep' = {
  scope: resourceGroup(rgName)
  name: 'deployHosts'
  dependsOn: [
    nicX
  ]

}

// az deployment sub create --location westeurope --template-file ./Bicep/main.bicep --parameters ./Bicep/deploy.parameters.json
