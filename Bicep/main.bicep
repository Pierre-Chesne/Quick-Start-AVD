targetScope = 'subscription'

param location string
param rgName string
param tokenExpirationTime string
param hostPoolName string
param pwdLocal string
param galleryImageDefinitionName string
param galleryImageVersionName string
param galleryNameResourceGroupName string
param galleryName string
param hostPoolType string
param loadBalancerType string
param maxSessionLimit int
param validationEnvironment bool
param applicationGroupType string
param dagName string
param workspaceName string
param numbersOfVm int
param vmSize string
param userNameLocal string
param hostNamePrefix string
param virtualNetworkResourceGroupName string
param virtualNetworkName string
param subnetName string
param domainUsernamePassword string
param domainName string
param domainUsername string

module rgModule 'rg.bicep' = {
  name: 'deployRgModule'  
  params: {
    location: location
    rgName: rgName 
  }
}

module hostPool0 'hostpools.bicep' = {
  scope: resourceGroup(rgName)
  name: 'deployHostPool0'
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
    hostNamePrefix: hostNamePrefix    
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
  params: {
    numbersOfVm: numbersOfVm
    hostNamePrefix: hostNamePrefix
    vmSize: vmSize
    userNameLocal: userNameLocal
    pwdLocal: pwdLocal
    galleryImageDefinitionName: galleryImageDefinitionName
    galleryImageVersionName: galleryImageVersionName
    galleryName: galleryName
    galleryNameResourceGroupName: galleryNameResourceGroupName
  }
  dependsOn: [
    nicX
  ]
}

module domainJoinX 'join_domain.bicep' = {
  scope: resourceGroup(rgName)
  name: 'deployJoinX'
  params: {
    numbersOfVm: numbersOfVm
    domainUsernamePassword: domainUsernamePassword
    domainName: domainName
    hostNamePrefix: hostNamePrefix
    domainUsername: domainUsername
  }
  dependsOn: [
    hostX
  ]
}

module agentsAVDX 'agent_AVD.bicep' = {
  scope: resourceGroup(rgName)
  name: 'deployagentsAVDX'
  params: {
    numbersOfVm: numbersOfVm
    hostNamePrefix: hostNamePrefix
    hostPoolName: hostPoolName    
  }
  dependsOn: [
    domainJoinX
  ]
}

// az deployment sub create --location westeurope --template-file ./Bicep/main.bicep --parameters ./Bicep/parameters/deploy.parameters.json 
