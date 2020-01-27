$resourceGroup = "withDeployment"
$location = "East US"
$templateFile = ".\function-app-windows-deploy.json"

#Remove-AzResourceGroup -Name sample -Force

Get-AzResourceGroup -Name $resourceGroup -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent) {
  New-AzResourceGroup -Name $resourceGroup -Location $location
}
   
$userPrinciple = Get-AzADUser -UserPrincipalName mclu@asicentral.com | Select-Object -ExpandProperty Id

New-AzResourceGroupDeployment `
  -Name functionappDeploy2 `
  -ResourceGroupName $resourceGroup `
  -TemplateFile $templateFile `
  -appName asideployFunc `
  -keyVaultPrincipleId $userPrinciple `
  #-Debug
