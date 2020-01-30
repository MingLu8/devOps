$userPrinciple = Get-AzADUser -UserPrincipalName mclu@asicentral.com | Select-Object -ExpandProperty Id
$functionPackageUri = "https://asideploymentstorage.blob.core.windows.net/deployments/webp/webp/publish.zip?sp=r&st=2020-01-29T14:49:37Z&se=2021-01-29T22:49:37Z&spr=https&sv=2019-02-02&sr=b&sig=JebH0th1EUgYQQJQcjzu12MYPT4KzcYUIKgXso%2BHbxA%3D"
$resourceGroup = "webp-group-ming"
$location = "East US"
$templateFile = ".\create-webp-function.json"
$parameterFile = ".\create-webp-function.parameters.dev.json"
#$templateParameterFile = ".\keyvaultdeploy.parameters.json"

$keyVaultName = "kv-webp-c2cxzbztq2q2g"
$blobStorageConnectionString = "https://kv-webp-c2cxzbztq2q2g.vault.azure.net/secrets/WebPStorageConnectionString/e23fd6a856b14b079e965a7d898a02dc"
$applicationInsightsName = "webpinsightsc2cxzbztq2q2g"


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
    -BlobStorageConnectionStringSecretKey $blobStorageConnectionString `
    -applicationInsightsName $applicationInsightsName `
    -keyVaultName $keyVaultName `
     -debug

