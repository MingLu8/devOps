$resourceGroup = "sample"
$location = "East US"
$templateFile = ".\azuredeploy.json"


# Remove-AzResourceGroup -Name sample -Force

Get-AzResourceGroup -Name $resourceGroup -ErrorVariable notPresent -ErrorAction SilentlyContinue

if($notPresent)
{
    New-AzResourceGroup -Name $resourceGroup -Location $location
}
    
New-AzResourceGroupDeployment `
  -Name sampleDeployment3 `
  -ResourceGroupName $resourceGroup `
  -TemplateFile $templateFile `
  -storagePrefix "asiming" `
  -storageSKU "Standard_LRS"
