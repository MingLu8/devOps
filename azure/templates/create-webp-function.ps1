$userPrinciple = Get-AzADUser -UserPrincipalName mclu@asicentral.com | Select-Object -ExpandProperty Id
$functionPackageUri = "https://asideploymentstorage.blob.core.windows.net/deployments/webp/webp/publish.zip?sp=r&st=2020-01-29T14:49:37Z&se=2021-01-29T22:49:37Z&spr=https&sv=2019-02-02&sr=b&sig=JebH0th1EUgYQQJQcjzu12MYPT4KzcYUIKgXso%2BHbxA%3D"
$resourceGroup = "webp-group-ming"
$location = "East US"
$templateFile = ".\create-webp-function.json"
$parameterFile = ".\create-webp-function.parameters.dev.json"
#$templateParameterFile = ".\keyvaultdeploy.parameters.json"

$keyVaultName = "kv-webp-xr2l3f7b3unbs"
$blobStorageConnectionString = az keyvault secret show --vault-name $keyVaultName --name WebPStorageConnectionString | ConvertFrom-Json | select -ExpandProperty Id
$applicationInsightsName = $keyVaultName.Replace("kv-webp-", "webpinsights")


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

