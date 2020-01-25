$userPrinciple = Get-AzADUser -UserPrincipalName mclu@asicentral.com | Select-Object -ExpandProperty Id

$resourceGroup = "samplewebpgroup"
$location = "East US"
$templateFile = ".\templates\add-secret-to-key-vault.json"
#$templateParameterFile = ".\keyvaultdeploy.parameters.json"
$keyVaultName = "samplekeyvault3"

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
  -secretName userprinciple2 `
  -secretValue $userPrinciple `
  #-debug