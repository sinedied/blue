param projectName string
param environmentName string
param location string
param tags object

var suffix = uniqueString(resourceGroup().id)

resource staticWebApp 'Microsoft.Web/staticSites@2021-01-15' = {
  name: 'website-${projectName}-${environmentName}-${suffix}'
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
