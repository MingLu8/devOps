
param (
    [Parameter(Mandatory = $true)][string]$environment
)


. .\helpers.ps1

if (!$environment) {
    $environment = Read-Host -Prompt 'Please enter the deployment environment: '
}

$deployResourceGroup = "deploy-storage-group"
$deployAccountName = "asideploymentstorage"
$deployContainerName = "deployments"
$queueFunctionPackage = "webp/queue-function/publish.zip"
$expiry = (Get-Date).AddDays(2).ToString("yyyy-MM-dd")

$webpQueueFunctionPackageUri = GetBlobUrl -resourceGroup $deployResourceGroup -accountName $deployAccountName -containerName $deployContainerName -blobName $queueFunctionPackage -expiry $expiry

$resourceGroup = "deploy-webp-group-ming13"
$location = "East US"
$templateFile = ".\create-webp-queue-function-app.json"
$templateParameterFile = ".\create-webp-queue-function-app.parameters.$environment.json"
$templateContainerName = "arm-templates"
$sasToken = GetStorageContainerSas $deployResourceGroup $deployAccountName $templateContainerName

$webpQueueFunctionAppName = "asi-ming-queue8"

az group create -l $location -n $resourceGroup
  
New-AzResourceGroupDeployment `
    -Name queueAppWebpDeployment `
    -ResourceGroupName $resourceGroup `
    -TemplateFile $templateFile `
    -templateParameterFile $templateParameterFile `
    -location $location `
    -sasToken $sasToken `
    -webpQueuefunctionPackageUri $webpQueueFunctionPackageUri `
    -webpQueueFunctionAppName $webpQueueFunctionAppName `
    # -debug

# "BlobStorageConnectionStringSecretKey": {
#         "reference": {
#             "keyVault": {
#                 "id": "[resourceId(subscription().subscriptionId,  resourceGroup().name, 'Microsoft.KeyVault/vaults', parameters('keyVaultName'))]"
#             },
#             "secretName": "[parameters('BlobStorageConnectionStringSecretName')]"
#         }
#     },