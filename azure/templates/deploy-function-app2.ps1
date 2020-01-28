$userPrinciple = Get-AzADUser -UserPrincipalName mclu@asicentral.com | Select-Object -ExpandProperty Id
$functionPackageUri = "https://asidevopsaccount.blob.core.windows.net/deployments/webp-converter/publish.zip?sp=r&st=2020-01-27T16:09:46Z&se=2021-01-28T00:09:46Z&spr=https&sv=2019-02-02&sr=b&sig=ljsKq2CMANtF74jF3PVDzoc04cLZfAuLIn8noWPXoOE%3D"
$resourceGroup = "test-add-func-group"
$location = "East US"
$templateFile = ".\add-function-app-main.json"
$parameterFile = ".\deploy-function-app2.parameters.dev.json"
$keyVaultName = "webpc2cxzbztq2q2g"
#$templateParameterFile = ".\keyvaultdeploy.parameters.json"
$blobStorageConnectionString = "https://webpc2cxzbztq2q2g.vault.azure.net/secrets/WebPStorageConnectionString/3c86503b58e44be591b108e922e84efd"
$WebPAppInsightInstrumentationKey = "https://webpc2cxzbztq2q2g.vault.azure.net/secrets/WebPAppInsightInstrumentationKey/00df6c63815d44da9276bee715ab14bd"
#Remove-AzResourceGroup -Name sample -Force

Get-AzResourceGroup -Name $resourceGroup -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent) {
    New-AzResourceGroup -Name $resourceGroup -Location $location
}
  
New-AzResourceGroupDeployment `
    -Name sampleWebpDeployment `
    -ResourceGroupName $resourceGroup `
    -TemplateFile $templateFile `
    -TemplateParameterFile $parameterFile `
    -location $location `
    -functionPackageUri $functionPackageUri `
    -keyVaultPrincipleId $userPrinciple `
    -BlobStorageConnectionStringSecretKey $blobStorageConnectionString `
    -appInsightsInstrumentationSecretKey $WebPAppInsightInstrumentationKey `
   # -debug