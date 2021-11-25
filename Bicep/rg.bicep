targetScope = 'subscription'

param rgName string
param location string

resource rg0 'Microsoft.Resources/resourceGroups@2021-04-01'= {
  name: rgName
  location: location
}
