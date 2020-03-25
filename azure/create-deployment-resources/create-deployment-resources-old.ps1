$userPrinciple = Get-AzADUser -UserPrincipalName mclu@asicentral.com | Select-Object -ExpandProperty Id
$resourceGroup = "deploy-storage-group"
$location = "East US"
$templateFile = ".\create-deployment-resources.json"
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
    -debug