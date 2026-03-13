// ─────────────────────────────────────────────────────────────────────────────
// Lucky 13 Pub Crawl — Azure Static Web App
// Deploy: az deployment group create --resource-group <rg> --template-file main.bicep
// ─────────────────────────────────────────────────────────────────────────────

targetScope = 'resourceGroup'

// ── Parameters ────────────────────────────────────────────────────────────────

@description('Short environment name used as a suffix (e.g. prod, staging)')
@allowed(['prod', 'staging', 'dev'])
param environment string = 'prod'

@description('Azure region for deployment — must be a region that supports Microsoft.Web/staticSites')
param location string = 'eastus2'

@description('Custom domain hostnames. DNS CNAME records must exist first.')
param customDomains array = []

// ── Variables ─────────────────────────────────────────────────────────────────

var appName = 'swa-lucky13-pubcrawl-${environment}'
var skuName = 'Standard'

var commonTags = {
  application: 'Lucky13PubCrawl'
  environment: environment
  managedBy: 'bicep'
  owner: 'WilliamGundersonFoundation'
}

// ── Modules ───────────────────────────────────────────────────────────────────

module swa 'modules/staticWebApp.bicep' = {
  name: '${appName}-deploy'
  params: {
    name: appName
    location: location
    skuName: skuName
    customDomains: customDomains
    tags: commonTags
  }
}

// ── Outputs ───────────────────────────────────────────────────────────────────

@description('Default Azure-assigned hostname')
output defaultHostname string = swa.outputs.defaultHostname

@description('Static Web App resource ID')
output resourceId string = swa.outputs.resourceId
