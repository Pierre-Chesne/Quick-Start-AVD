param hostPoolName string
param hostPoolType string
param maxSessionLimit int
param loadBalancerType string
param validationEnvironment bool
param expirationTime string

resource hostPools0 'Microsoft.DesktopVirtualization/hostPools@2021-09-03-preview'= {
  name: hostPoolName
  location: resourceGroup().location
  properties: {
    hostPoolType: hostPoolType
    maxSessionLimit: maxSessionLimit
    loadBalancerType: loadBalancerType
    validationEnvironment: validationEnvironment
    registrationInfo: {
      registrationTokenOperation: 'Update'
      expirationTime: expirationTime
      token: null
    }
    preferredAppGroupType: 'Desktop'
  }
}
