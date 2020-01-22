$resourceGroup = "sample"
$location = "East US"
$templateFile = ".\azuredeploy.json"
$templateParameterFile = ".\azuredeploy.parameters.json"


# Remove-AzResourceGroup -Name sample -Force

Get-AzResourceGroup -Name $resourceGroup -ErrorVariable notPresent -ErrorAction SilentlyContinue

if($notPresent) {
    New-AzResourceGroup -Name $resourceGroup -Location $location
}
    
# Set-AzKeyVaultAccessPolicy -VaultName ExampleVault -EnabledForTemplateDeployment

# Get-AzKeyVault -VaultName sample -ResourceGroupName sample -ErrorVariable noVaultExists
# if($noVaultExists) {
#     New-AzKeyVault -VaultName ExampleVault -resourceGroupName $resourceGroup -Location $location -EnabledForTemplateDeployment
# }
    
# $secretvalue = ConvertTo-SecureString 'hVFkk965BuUv' -AsPlainText -Force
# $secret = Set-AzKeyVaultSecret -VaultName ExampleVault -Name 'ExamplePassword' -SecretValue $secretvalue

New-AzResourceGroupDeployment `
  -Name sampleDeployment3 `
  -ResourceGroupName $resourceGroup `
  -TemplateFile $templateFile `
  -TemplateParameterFile $templateParameterFile `
  -storagePrefix "asiming" `
  -storageSKU "Standard_LRS"
