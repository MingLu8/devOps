$userPrinciple = Get-AzADUser -UserPrincipalName mclu@asicentral.com | Select-Object -ExpandProperty Id
$resourceGroup = "webp-group"
$location = "East US"
$templateFile = ".\create-webp-convert-function.json"
$functionPackageUri = "https://asideploymentstorage.blob.core.windows.net/deployments/webp/webp/publish.zip?sp=r&st=2020-01-28T02:00:30Z&se=2021-01-28T10:00:30Z&spr=https&sv=2019-02-02&sr=b&sig=mmzkBZEarOY2r8dll%2FHTfHyjCx6YI%2BwY9kqSJWT%2FOK8%3D"
$keyVaultName = "webpkeyvault"
$functionAppName = "webp"

#$templateParameterFile = ".\keyvaultdeploy.parameters.json"

#Remove-AzResourceGroup -Name sample -Force

Get-AzResourceGroup -Name $resourceGroup -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent) {
    New-AzResourceGroup -Name $resourceGroup -Location $location
}
  
New-AzResourceGroupDeployment `
    -Name created `
    -ResourceGroupName $resourceGroup `
    -TemplateFile $templateFile `
    -keyVaultName $keyVaultName `
    -appName $functionAppName `
    -keyVaultPrincipleId $userPrinciple `
    -functionPackageUri $functionPackageUri `
    -debug
    
# Write-Output "deployment completed. updating app config settings..."

# $secretId = az keyvault secret show --vault-name $keyVaultName --name webpFunctionKey | ConvertFrom-Json | select -ExpandProperty Id
# $setting = "webpFunctionKey=@Microsoft.KeyVault(SecretUri=$secretId)"
# az webapp config appsettings set -g $resourceGroup -n $functionAppName --settings $setting
