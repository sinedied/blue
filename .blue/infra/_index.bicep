@minLength(3)
@maxLength(32)
param projectName string
@minLength(3)
@maxLength(16)
param environmentName string = 'prod'
param location string = 'westus'

var commonTags = {
  project: projectName
  environment: environmentName
  managedBy: 'blue'
}

targetScope = 'subscription'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2020-10-01' = {
  name: 'rg-${projectName}-${environmentName}' 
  location: location
  tags: commonTags
}

module website './website.bicep' = {
  name: 'website'
  scope: resourceGroup
  params: {
    projectName: projectName
    environmentName: environmentName
    location: location
    tags: commonTags
  }
}
