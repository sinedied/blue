// ---------------------------------------------------------------------------
// Common parameters
param projectName string
param environment string
param location string
param tags object

// Resource-specific parameters
param collections array = []

// ---------------------------------------------------------------------------

var suffix = uniqueString(resourceGroup().id)

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2021-06-15' = {
  name: 'db-${projectName}-${environment}-${suffix}'
  location: location
  tags: tags
  kind: 'GlobalDocumentDB'
  properties: {
    publicNetworkAccess: 'Enabled'
    enableAutomaticFailover: false
    // enableMultipleWriteLocations: false
    databaseAccountOfferType: 'Standard'
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
      maxIntervalInSeconds: 5
      maxStalenessPrefix: 100
    }
    locations: [
      {
        locationName: location
        // isZoneRedundant: false
      }
    ]
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
    backupPolicy: {
      type: 'Periodic'
      periodicModeProperties: {
        backupIntervalInMinutes: 240
        backupRetentionIntervalInHours: 8
      }
    }
  }
}

resource cosmosDbDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-06-15' = {
  parent: cosmosDb
  name: '${projectName}db'
  properties: {
    resource: {
      id: '${projectName}db'
    }
  }

  resource cosmosDbContainer 'containers@2021-04-15' = {
    name: 'users'
    properties: {
      resource: {
        id: 'users'
        partitionKey: {
          paths: [
            '/id'
          ]
          kind: 'Hash'
        }
      }
    }
  }
}
