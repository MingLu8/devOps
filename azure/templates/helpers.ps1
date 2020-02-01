
# $deployResourceGroup = "deploy-storage-group"
# $deployAccountName = "asideploymentstorage"
# $deployContainerName = "deployments"
# $queueFunctionPackage = "webp/queue-function/publish.zip"
# $expiry = (Get-Date).AddDays(1).ToString("yyyy-MM-dd")

function GetStorageAccountKey([string] $resourceGroup, [string] $accountName) {
    return $(az storage account keys list -g $resourceGroup -n $accountName | ConvertFrom-json)[0].value
}

function GetStorageContainerSas([string]$resourceGroup, [string] $accountName, [string] $containerName) {
    $accountKey = GetStorageAccountKey $resourceGroup $accountName
    $expiry = (Get-Date).AddDays(2).ToString("yyyy-MM-dd")
    $sas = az storage container generate-sas --account-name $accountName --name $containerName --permissions r --start (Get-Date).ToString("yyyy-MM-dd") --expiry $expiry --account-key $accountKey -o tsv
    return $sas
}
function GetBlobUrl([string]$resourceGroup, [string]$accountName, [string]$containerName, [string]$blobName, [string]$expiry) {
    
    $firstKey = GetStorageAccountKey $resourceGroup $accountName

    $url = az storage blob generate-sas `
        --account-name $accountName `
        --account-key $firstKey `
        --container-name $containerName `
        --name $blobName `
        --permissions r `
        --full-uri `
        --https-only `
        --start (Get-Date).ToString("yyyy-MM-dd") `
        --expiry $expiry  -o tsv

    # $blobUrl = az storage blob url `
    #     --account-name $accountName `
    #     --container-name $containerName `
    #     --name $blobName -o tsv

    # $url = -join ($blobUrl, "?", $blobSas)
    return $url
}


#GetBlobUrl -resourceGroup $deployResourceGroup -accountName $deployAccountName -containerName $deployContainerName -blobName $queueFunctionPackage -expiry $expiry
# $resourceGroup = "webp-rg"
# $deploymentResourceGroup = "deploy-storage-group"
# $accountName = "asideploymentstorage"
# $containerName = "arm-templates"
# $templateFile = ".\create-shared-resources.json"
# $templateBaseUrl = "https://asideploymentstorage.blob.core.windows.net/arm-templates"
# $sasToken = GetStorageContainerSas $deploymentResourceGroup $accountName $containerName
# $url = -join ($templateBaseUrl, "/common/create-key-vault.json?", $sasToken)
# Write-Output $url


$deployResourceGroup = "deploy-storage-group"
$deployAccountName = "asideploymentstorage"
$deployContainerName = "deployments"
$webpFunctionPackage = "webp/webp/publish.zip"
$expiry = (Get-Date).AddDays(2).ToString("yyyy-MM-dd")

GetBlobUrl -resourceGroup $deployResourceGroup -accountName $deployAccountName -containerName $deployContainerName -blobName $webpFunctionPackage -expiry $expiry