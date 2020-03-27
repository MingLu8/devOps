$subscriptionName = "Visual Studio Enterprise"
$resourceGroup = "mclu-image-service-data4"
$devOpsServicePrincipleName = "devOps2"
$prefix = "mclu"
$postfix = "deva"
$optionalUserToAccessKeyvault = "ming.lu@live.com"  #for debugging
$location = "East US"
$templateFile = ".\azuredeploy.json"
$templateParameterFile = ".\azuredeploy.parameters.json"

#Remove-AzResourceGroup -Name sample -Force

Get-AzResourceGroup -Name $resourceGroup -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent) {
    New-AzResourceGroup -Name $resourceGroup -Location $location
}
   
$subscriptionId = Get-AzureSubscription -SubscriptionName $subscriptionName | Select-Object -ExpandProperty SubscriptionId
New-AzADServicePrincipal -Role Contributor -DisplayName $devOpsServicePrincipleName -Scope "/subscriptions/$subscriptionId/resourceGroups/$resourceGroup"

$userPrinciple = Get-AzADUser -SearchString $optionalUserToAccessKeyvault -First 1 | Select-Object -ExpandProperty Id
$resourceGroupServicePrinciple = Get-AzADServicePrincipal  -DisplayName $devOpsServicePrincipleName | Select-Object -ExpandProperty Id
New-AzADSpCredential -ObjectId $resourceGroupServicePrinciple -EndDate (Get-Date -Year 3020)

New-AzResourceGroupDeployment `
    -Name sampleWebpDeployment `
    -ResourceGroupName $resourceGroup `
    -TemplateFile $templateFile `
    -TemplateParameterFile $templateParameterFile `
    -DeploymentDebugLogLevel All `
    -location $location `
    -keyVaultAccessServicePrinciples "$userPrinciple, $resourceGroupServicePrinciple" `
    -prefix $prefix `
    -postfix $postfix `
