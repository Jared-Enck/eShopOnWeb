param webAppName string = 'eshop-${uniqueString(resourceGroup().id)}' // globally-unique-ish
param sku string = 'S1'        // App Service Plan SKU (Standard S1)
param location string = resourceGroup().location

var appServicePlanName = toLower('asp-${webAppName}')
var siteName           = toLower(webAppName)

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  kind: 'linux'
  sku: {
    name: sku
    tier: 'Standard'
    size: 'S1'
  }
  properties: {
    reserved: true // Linux
  }
}

resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: siteName
  kind: 'app,linux'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      // For Linux, .NET 8 runtime is DOTNET|8.0 (not DOTNETCORE|8.0)
      linuxFxVersion: 'DOTNET|8.0'
      alwaysOn: true
      appSettings: [
        { name: 'ASPNETCORE_ENVIRONMENT'; value: 'Development' }
        { name: 'UseOnlyInMemoryDatabase'; value: 'true' }
      ]
    }
  }
}
