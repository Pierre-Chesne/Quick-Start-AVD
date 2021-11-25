param workspaceName string
param applicationGroupReferences string

resource workspace0 'Microsoft.DesktopVirtualization/workspaces@2021-09-03-preview' = {
  name: workspaceName
  location: resourceGroup().location
  properties: {
     applicationGroupReferences :[
      applicationGroupReferences
     ]
  }
}
