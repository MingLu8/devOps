$userPrinciple = Get-AzADUser -UserPrincipalName mclu@asicentral.com | Select-Object -ExpandProperty Id
$functionPackageUri = "https://asidevopsaccount.blob.core.windows.net/deployments/webp-converter/publish.zip?sp=r&st=2020-01-27T16:09:46Z&se=2021-01-28T00:09:46Z&spr=https&sv=2019-02-02&sr=b&sig=ljsKq2CMANtF74jF3PVDzoc04cLZfAuLIn8noWPXoOE%3D"
$resourceGroup = "webp-group"
$location = "East US"
$templateFile = ".\linkedTemplateSample.json"
#$templateParameterFile = ".\keyvaultdeploy.parameters.json"
$keyVaultName = "webpsamplevault"

#Remove-AzResourceGroup -Name sample -Force

Get-AzResourceGroup -Name $resourceGroup -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent) {
    New-AzResourceGroup -Name $resourceGroup -Location $location
}
  
New-AzResourceGroupDeployment `
    -Name sampleWebpDeployment `
    -ResourceGroupName $resourceGroup `
    -TemplateFile $templateFile `
    -keyVaultName $keyVaultName `
    -location $location `
    -keyVaultPrincipleId $userPrinciple `
    -functionPackageUri $functionPackageUri `
    #-debug