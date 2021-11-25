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

// az deployment sub create --location westeurope --template-file ./Bicep/main.bicep --parameters ./Bicep/deploy.parameters.json
