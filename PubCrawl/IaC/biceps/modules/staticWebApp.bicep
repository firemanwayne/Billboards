// ─────────────────────────────────────────────────────────────────────────────
// Module: Azure Static Web App (with optional custom domains)
// ─────────────────────────────────────────────────────────────────────────────

@description('Name of the Static Web App resource')
param name string

@description('Azure region for deployment')
param location string = 'centralus'

@description('SKU tier — Free or Standard (custom domains require Standard)')
@allowed(['Free', 'Standard'])
param skuName string = 'Standard'

@description('List of custom domain hostnames to associate (e.g. ["www.lucky13pubcrawl.com"])')
param customDomains array = []

@description('Resource tags')
param tags object = {}

// ── Static Web App ────────────────────────────────────────────────────────────
resource staticWebApp 'Microsoft.Web/staticSites@2023-01-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: skuName
  }
  properties: {
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    enterpriseGradeCdnStatus: 'Disabled'
  }
}

// ── Custom Domains ────────────────────────────────────────────────────────────
// NOTE: Before adding a custom domain the DNS CNAME/TXT record must already
//       exist pointing to the SWA default hostname.
//       DNS validation is automatic — Azure issues a managed TLS cert.
@batchSize(1)
resource customDomainBindings 'Microsoft.Web/staticSites/customDomains@2023-01-01' = [
  for domain in customDomains: {
    name: domain
    parent: staticWebApp
    properties: {}
  }
]

// ── Outputs ───────────────────────────────────────────────────────────────────
@description('The deployed Static Web App resource')
output resource object = staticWebApp

@description('Static Web App default hostname')
output defaultHostname string = staticWebApp.properties.defaultHostname

@description('Static Web App resource ID')
output resourceId string = staticWebApp.id

@description('Deployment token — store as a GitHub secret (AZURE_STATIC_WEB_APPS_API_TOKEN)')
output deploymentToken string = staticWebApp.listSecrets().properties.apiKey
