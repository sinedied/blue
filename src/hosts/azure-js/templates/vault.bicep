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
  'standard'
  'premium'
])
param tier string = 'standard'

// ---------------------------------------------------------------------------

var suffix = uniqueString(resourceGroup().id, environment)

// Built-in Key Vault roles
// https://docs.microsoft.com/azure/key-vault/general/rbac-guide?tabs=azure-cli#azure-built-in-roles-for-key-vault-data-plane-operations
var keyVaultRoleIdMapping = {
  'Key Vault Administrator': '00482a5a-887f-4fb3-b363-3b7fe8e74483'
  'Key Vault Certificates Officer': 'a4417e6f-fecd-4de8-b567-7b0420556985'
  'Key Vault Crypto Officer': '14b46e9e-c2b7-41b4-b07b-48a6ebf60603'
  'Key Vault Crypto Service Encryption User': 'e147488a-f6f5-4113-8e2d-b22465e65bf6'
  'Key Vault Crypto User': '12338af0-0e69-4776-bea7-57ae8d297424'
  'Key Vault Reader': '21090545-7ca7-4776-b22c-e363652d74d2'
  'Key Vault Secrets Officer': 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'
  'Key Vault Secrets User': '4633458b-17de-408a-b874-0445c86b69e6'
}

// User Assigned Identity
// https://docs.microsoft.com/azure/templates/microsoft.managedidentity/userassignedidentities?tabs=bicep
resource keyVaultUser 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'kvu-${projectName}-${environment}-${suffix}'
  location: location
  tags: tags
}

// Role Assignment
// https://docs.microsoft.com/azure/templates/microsoft.authorization/roleassignments?tabs=bicep
resource keyVaultRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(keyVaultRoleIdMapping['Key Vault Secrets User'], keyVaultUser.id, keyVault.id)
  scope: keyVault
  properties: {
    principalId: keyVaultUser.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', keyVaultRoleIdMapping['Key Vault Secrets User'])
  }
}

// Azure Key Vault
// https://docs.microsoft.com/azure/templates/microsoft.keyvault/vaults?tabs=bicep
resource keyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: 'kv-${suffix}'
  location: location
  tags: tags
  properties: {
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enabledForDeployment: true
    enabledForTemplateDeployment: false
    enabledForDiskEncryption: false
    accessPolicies: []
    sku: {
      name: tier
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}
