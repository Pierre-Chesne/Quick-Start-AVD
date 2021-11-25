targetScope = 'subscription'

param location string
param rgName string
param expirationTime string
param hostPoolName string
param hostPoolType string
param loadBalancerType string
param maxSessionLimit int
param validationEnvironment bool


module rgModule 'rg.bicep' = {
  name: 'deployRgModule'  
  params: {
    location: location
    rgName: rgName 
  }
}

module hostPools0 'hostpools.bicep' = {
  scope: resourceGroup(rgName)
  name: 'deployHostPool'
  params: {
    expirationTime: expirationTime
    hostPoolName: hostPoolName
    hostPoolType: hostPoolType
    loadBalancerType: loadBalancerType
    maxSessionLimit: maxSessionLimit
    validationEnvironment: validationEnvironment
  }
}
// az deployment sub create --location westeurope --template-file ./Bicep/main.bicep --parameters ./Bicep/deploy.parameters.json
