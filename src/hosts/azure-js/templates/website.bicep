param projectName string
param environment string
param location string
param tags object

var suffix = uniqueString(resourceGroup().id, environment)

resource staticWebApp 'Microsoft.Web/staticSites@2021-01-15' = {
  name: 'website-${projectName}-${environment}-${suffix}'
  location: location
  tags: tags
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
  properties: {
    provider: 'custom'
    buildProperties: {
      skipGithubActionWorkflowGeneration: true
    }
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
  }
}
