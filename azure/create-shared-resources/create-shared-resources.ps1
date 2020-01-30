$userPrinciple = Get-AzADUser -UserPrincipalName mclu@asicentral.com | Select-Object -ExpandProperty Id
$resourceGroup = "webp-group-ming3"
$location = "East US"
$templateFile = ".\create-shared-resources.json"
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
    -keyVaultPrincipleId $userPrinciple `
    #-debug

    
# $secretId = az keyvault secret show --vault-name $keyVaultName --name webpFunctionKey | ConvertFrom-Json | select -ExpandProperty Id
# $setting = "webpFunctionKey=@Microsoft.KeyVault(SecretUri=$secretId)"