param dagName string
param applicationGroupType string
param hostPoolArmPath string


resource applicationGroup0 'Microsoft.DesktopVirtualization/applicationGroups@2021-09-03-preview'= {
  name: dagName
  location: resourceGroup().location
  properties: {
    applicationGroupType: applicationGroupType
    hostPoolArmPath: hostPoolArmPath
  }
}