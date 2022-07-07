//----------------------------------------------------------------------------
// THIS FILE IS AUTO-GENERATED, DO NOT EDIT IT MANUALLY!
// If you need to make changes, edit the file `blue.yaml`.
//----------------------------------------------------------------------------

@minLength(1)
@maxLength(24)
@description('The name of your project')
param projectName string

@minLength(1)
@maxLength(10)
@description('The name of the environment')
param environment string = 'prod'

@description('The Azure region where all resources will be created')
param location string = 'eastus'

var commonTags = {
  project: projectName
  environment: environment
  managedBy: 'blue'
}

targetScope = 'subscription'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2020-10-01' = {
  name: 'rg-${projectName}-${environment}' 
  location: location
  tags: commonTags
}

module website './website.bicep' = {
  name: 'website'
  scope: resourceGroup
  params: {
    projectName: projectName
    environment: environment
    location: location
    tags: commonTags
  }
}
