// ---------------------------------------------------------------------------
// Common parameters for all modules
// ---------------------------------------------------------------------------

@minLength(1)
@maxLength(24)
@description('The name of your project')
param projectName string

@minLength(1)
@maxLength(10)
@description('The name of the environment')
param environment string

@description('The Azure region where all resources will be created')
param location string = resourceGroup().location

@description('Tags for the resources')
param tags object = {}

// ---------------------------------------------------------------------------
// Resource-specific parameters
// ---------------------------------------------------------------------------

@description('Specifies the service tier')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param tier string = 'Basic'

// ---------------------------------------------------------------------------

var suffix = uniqueString(resourceGroup().id, environment)

// Azure Container Registry
// https://docs.microsoft.com/en-us/azure/templates/microsoft.containerregistry/registries?tabs=bicep
resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: 'cr${projectName}${environment}${suffix}'
  location: location
  tags: tags
  sku: {
    name: tier
  }
  properties: {
    adminUserEnabled: true
  }
}

output name string = containerRegistry.name
