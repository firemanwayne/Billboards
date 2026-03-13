// ─────────────────────────────────────────────────────────────────────────────
// Lucky 13 Pub Crawl — Azure Static Web App
// Deploy: az deployment group create --resource-group <rg> --template-file main.bicep
// ─────────────────────────────────────────────────────────────────────────────

targetScope = 'resourceGroup'

// ── Parameters ────────────────────────────────────────────────────────────────

@description('Short environment name used as a suffix (e.g. prod, staging)')
@allowed(['prod', 'staging', 'dev'])
param environment string = 'prod'

@description('Azure region for deployment')
param location string = resourceGroup().location

@description('Custom domain hostnames to associate with the SWA. '
  + 'DNS CNAME/TXT records must exist before running. '
  + 'Example: ["lucky13pubcrawl.com", "www.lucky13pubcrawl.com"]')
param customDomains array = []

// ── Variables ─────────────────────────────────────────────────────────────────

var appName    = 'swa-lucky13-pubcrawl-${environment}'
var skuName    = 'Standard'   // Standard required for custom domains

var commonTags = {
  application : 'Lucky13PubCrawl'
  environment : environment
  managedBy   : 'bicep'
  owner       : 'WilliamGundersonFoundation'
}

// ── Modules ───────────────────────────────────────────────────────────────────

module swa 'modules/staticWebApp.bicep' = {
  name: '${appName}-deploy'
  params: {
    name          : appName
    location      : location
    skuName       : skuName
    customDomains : customDomains
    tags          : commonTags
  }
}

// ── Outputs ───────────────────────────────────────────────────────────────────

@description('Default Azure-assigned hostname')
output defaultHostname string = swa.outputs.defaultHostname

@description('Copy this token into the GitHub secret AZURE_STATIC_WEB_APPS_API_TOKEN')
output deploymentToken string = swa.outputs.deploymentToken

@description('Static Web App resource ID')
output resourceId string = swa.outputs.resourceId
