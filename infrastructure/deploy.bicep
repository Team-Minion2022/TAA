param location string = 'southeastasia'
param tenantGuid string
param appServicePlanName string
param keyVaultName string
param webAppName string
param resourceGroupServicePrincipalManagedApplicationObjectId string

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName
  location: location
  sku: {
    tier: 'Standard'
    name: 'S1'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: webAppName
  location: location
  kind: 'app,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: []
      linuxFxVersion: 'DOTNETCORE|3.1'
      alwaysOn: true
    }
  }
}

module keyVaultDeploy 'keyVault.bicep'={
    name:keyVaultName
    params:{
      keyVaultName : keyVaultName
      location : location
      tenantGuid : tenantGuid
      identitiesThatRequiredSecretAccessPolicies : [
        resourceGroupServicePrincipalManagedApplicationObjectId
        webApp.identity.principalId
      ]
    }
  }
