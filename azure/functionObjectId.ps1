$resourceGroup = "samplefunctionapp"
$location = "East US"
$templateFile = ".\functionObjectId.json"

#Remove-AzResourceGroup -Name sample -Force

Get-AzResourceGroup -Name $resourceGroup -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent) {
  New-AzResourceGroup -Name $resourceGroup -Location $location
}
    
New-AzResourceGroupDeployment `
  -Name functionappDeploy `
  -ResourceGroupName $resourceGroup `
  -TemplateFile $templateFile `
  # -Debug
  # New-AzDeployment `
#   -Name functionappDeploy `
#   -Location $location `
#   -TemplateFile $templateFile `
#  -Debug
