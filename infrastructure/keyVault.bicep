
param keyVaultName string
param location string
param tenantGuid string

param identitiesThatRequiredSecretAccessPolicies array

//param webAppManagedIdentityObjectId string
//param resourceGroupServicePrincipalManagedApplicationObjectId string

var yourAadUserObjectId= '1a4265bf-a3b7-4cd9-9423-f77ae65c1675'

var userObjectIdsToGrantAccessPoliciesThatAllowFullControlForAllEntitiesInKeyVault = [
  yourAadUserObjectId
]


var fullControlForAllEntitiesInKeyVaultAccessPolicies = [for userObjectId in userObjectIdsToGrantAccessPoliciesThatAllowFullControlForAllEntitiesInKeyVault: {
  tenantId: tenantGuid
  objectId: userObjectId
  permissions: {
    keys: [
      'get'
      'list'
      'update'
      'create'
      'import'
      'delete'
      'recover'
      'backup'
      'restore'
    ]
    secrets: [
      'get'
      'list'
      'set'
      'delete'
      'recover'
      'backup'
      'restore'
    ]
    certificates: [
      'get'
      'list'
      'update'
      'create'
      'import'
      'delete'
      'recover'
      'backup'
      'restore'
      'managecontacts'
      'manageissuers'
      'getissuers'
      'listissuers'
      'setissuers'
      'deleteissuers'
    ]
  }
}]

var accessForSecretsInKeyVaultAccessPolicies = [for identityObjectId in identitiesThatRequiredSecretAccessPolicies: {
  tenantId: tenantGuid
  objectId: identityObjectId
  permissions: {
    keys: []
    secrets: [
      'get'
      'list'
      'set'
      'delete'
      'recover'
      'backup'
      'restore'
    ]
    certificates: []
  }
}]

var keyVaultAccessPolicies = union(fullControlForAllEntitiesInKeyVaultAccessPolicies, accessForSecretsInKeyVaultAccessPolicies)


resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: tenantGuid
    softDeleteRetentionInDays: 90
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enableRbacAuthorization: false
    enableSoftDelete: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
      ipRules: []
      virtualNetworkRules: []
    }
    accessPolicies: keyVaultAccessPolicies
  }
}
