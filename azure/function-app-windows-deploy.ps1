$resourceGroup = "samplefunctionapp"
$location = "East US"
$templateFile = ".\function-app-windows-deploy.json"

#Remove-AzResourceGroup -Name sample -Force

Get-AzResourceGroup -Name $resourceGroup -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent) {
  New-AzResourceGroup -Name $resourceGroup -Location $location
}
    
New-AzResourceGroupDeployment `
  -Name functionappDeploy `
  -ResourceGroupName $resourceGroup `
  -TemplateFile $templateFile `
  -appName asifunctionappsample9
#-Debug
