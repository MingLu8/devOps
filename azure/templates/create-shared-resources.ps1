
. .\helpers.ps1

param (
    [Parameter(Mandatory = $true)][string]$environment
)

if (!$environment) {
    $environment = Read-Host -Prompt 'Please enter the deployment environment: '
}

# az storage container generate-sas `
#     --account-name asideploymentstorage `
#     --name deployments `
#     --permissions r `
#     --expiry (Get-Date).AddHours(5).ToString("yyyy-MM-dd") `
#     --account-key olqogosXH8MAq29PJjX/y5wJmC3npu/C8FUTZtndL6/vEtmaJ/gch98xMsZvtDqcjXk4z4Dp+TLaQTAZ+0lksw==

# $userPrinciple = Get-AzADUser -UserPrincipalName mclu@asicentral.com | Select-Object -ExpandProperty Id
# $functionPackageUri = "https://asideploymentstorage.blob.core.windows.net/deployments/webp/webp/publish.zip?sp=r&st=2020-01-30T05:48:32Z&se=2021-01-30T13:48:32Z&spr=https&sv=2019-02-02&sr=b&sig=lPpnWIQmOEhU9Voh4KRt0xZROcWjJRtIprIs9jd42As%3D"


$resourceGroup = "webp-rg4"
$deploymentResourceGroup = "deploy-storage-group"
$accountName = "asideploymentstorage"
$containerName = "arm-templates"
$location = "East US"
$templateFile = ".\create-shared-resources.json"
$sasToken = GetStorageContainerSas $deploymentResourceGroup $accountName $containerName
$templateParameterFile = "./create-shared-resources.parameters.$environment.json"

az group create -l $location -n $resourceGroup
  
#az group deployment create -g $resourceGroup --template-file $templateFile --parameters @$templateParameterFile --parameters templateBaseUrl=$templateBaseUrl --parameters sasToken=$sasToken
New-AzResourceGroupDeployment `
    -Name deploySharedResource `
    -ResourceGroupName $resourceGroup `
    -TemplateFile $templateFile `
    -TemplateParameterFile $templateParameterFile `
    -sasToken $sasToken `
    # -debug