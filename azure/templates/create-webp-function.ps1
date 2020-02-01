
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
$webpFunctionPackage = "webp/webp/publish.zip"
$expiry = (Get-Date).AddDays(2).ToString("yyyy-MM-dd")

$functionPackageUri = GetBlobUrl -resourceGroup $deployResourceGroup -accountName $deployAccountName -containerName $deployContainerName -blobName $webpFunctionPackage -expiry $expiry

$resourceGroup = "deploy-webp-group-ming13"
$functionAppName = "azure-webp2"
$location = "East US"
$templateFile = ".\create-webp-function.json"
$templateContainerName = "arm-templates"
$sasToken = GetStorageContainerSas $deployResourceGroup $deployAccountName $templateContainerName
$templateParameterFile = "./create-webp-function.parameters.$environment.json"

az group create -l $location -n $resourceGroup

New-AzResourceGroupDeployment `
    -Name sampleWebpDeployment2 `
    -ResourceGroupName $resourceGroup `
    -TemplateFile $templateFile `
    -TemplateParameterFile $templateParameterFile `
    -location $location `
    -sasToken $sasToken `
    -functionPackageUri $functionPackageUri `
    -functionAppName $functionAppName `
    # -debug

