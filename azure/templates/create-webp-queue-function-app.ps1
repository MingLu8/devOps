
. .\helpers.ps1

$deployResourceGroup = "deploy-storage-group"
$deployAccountName = "asideploymentstorage"
$deployContainerName = "deployments"
$queueFunctionPackage = "webp/queue-function/publish.zip"
$expiry = (Get-Date).AddDays(1).ToString("yyyy-MM-dd")

$webpQueueFunctionPackageUri = GetBlobUrl -resourceGroup $deployResourceGroup -accountName $deployAccountName -containerName $deployContainerName -blobName $queueFunctionPackage -expiry $expiry
#$webpQueueFunctionPackageUri = "https://asideploymentstorage.blob.core.windows.net/deployments/webp/queue-function/publish.zip?sp=r&st=2020-01-30T19:41:47Z&se=2021-01-31T03:41:47Z&spr=https&sv=2019-02-02&sr=b&sig=FbP8YBTcNrrJ77asXSOuyTwfPYhluOY1mxtJ9tpZ5jE%3D"

$resourceGroup = "deploy-webp-group-ming13"
$location = "East US"
$templateFile = ".\create-webp-queue-function-app.json"
$templateParameterFile = ".\create-webp-queue-function-app.parameters.dev.json"
$templateBaseUrl = "https://raw.githubusercontent.com/MingLu8/devOps/master/azure"

# $BlobStorageConnectionStringSecretKey = "https://kv-func-appiq6utczxrw2yi.vault.azure.net/secrets/WebPStorageConnectionString/3603c30c2bf04832ba60804d48a1466a"

$webpQueueFunctionAppName = "asi-ming-queue7"
#Remove-AzResourceGroup -Name sample -Force

Get-AzResourceGroup -Name $resourceGroup -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent) {
    New-AzResourceGroup -Name $resourceGroup -Location $location
}
  
New-AzResourceGroupDeployment `
    -Name queueAppWebpDeployment `
    -ResourceGroupName $resourceGroup `
    -TemplateFile $templateFile `
    -templateParameterFile $templateParameterFile `
    -location $location `
    -webpQueuefunctionPackageUri $webpQueueFunctionPackageUri `
    -templateBaseUrl $templateBaseUrl `
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