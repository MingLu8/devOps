$userPrinciple = Get-AzADUser -UserPrincipalName mclu@asicentral.com | Select-Object -ExpandProperty Id
$functionPackageUri = "https://asideploymentstorage.blob.core.windows.net/deployments/webp/webp/publish.zip?sp=r&st=2020-01-29T14:49:37Z&se=2021-01-29T22:49:37Z&spr=https&sv=2019-02-02&sr=b&sig=JebH0th1EUgYQQJQcjzu12MYPT4KzcYUIKgXso%2BHbxA%3D"
$resourceGroup = "webp-group-ming"
$location = "East US"
$templateFile = ".\add-function-app-main.json"
$parameterFile = ".\deploy-function-app2.parameters.dev.json"
#$templateParameterFile = ".\keyvaultdeploy.parameters.json"

$keyVaultName = "kv-webp-c2cxzbztq2q2g"
$blobStorageConnectionString = "https://kv-webp-c2cxzbztq2q2g.vault.azure.net/secrets/WebPAppInsightInstrumentationKey/434871c15f334520936ff6052f7ca03e"
$WebPAppInsightInstrumentationKey = "https://kv-webp-c2cxzbztq2q2g.vault.azure.net/secrets/WebPStorageConnectionString/d6107c08bd6c44eea6f2fd4e3990538d"


#Remove-AzResourceGroup -Name sample -Force

Get-AzResourceGroup -Name $resourceGroup -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent) {
    New-AzResourceGroup -Name $resourceGroup -Location $location
}
  
New-AzResourceGroupDeployment `
    -Name sampleWebpDeployment2 `
    -ResourceGroupName $resourceGroup `
    -TemplateFile $templateFile `
    -TemplateParameterFile $parameterFile `
    -location $location `
    -functionPackageUri $functionPackageUri `
    -keyVaultPrincipleId $userPrinciple `
    -BlobStorageConnectionStringSecretKey $blobStorageConnectionString `
    -appInsightsInstrumentationSecretKey $WebPAppInsightInstrumentationKey `
    -keyVaultName $keyVaultName `
    # -debug

