$resourceGroup = "mclu-deployment-infrastructure"
$location = "East US"
$templateFile = ".\azuredeploy.json"
$templateParameterFile = ".\azuredeploy.parameters.json"

#Remove-AzResourceGroup -Name sample -Force

Get-AzResourceGroup -Name $resourceGroup -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent) {
    New-AzResourceGroup -Name $resourceGroup -Location $location
}
   


New-AzResourceGroupDeployment `
    -Name sampleWebpDeployment `
    -ResourceGroupName $resourceGroup `
    -TemplateFile $templateFile `
    -TemplateParameterFile $templateParameterFile `
    -DeploymentDebugLogLevel All `
    -location $location