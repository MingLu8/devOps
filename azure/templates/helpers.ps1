
# $deployResourceGroup = "deploy-storage-group"
# $deployAccountName = "asideploymentstorage"
# $deployContainerName = "deployments"
# $queueFunctionPackage = "webp/queue-function/publish.zip"
# $expiry = (Get-Date).AddDays(1).ToString("yyyy-MM-dd")
function GetBlobUrl([string]$resourceGroup, [string]$accountName, [string]$containerName, [string]$blobName, [string]$expiry) {
    
    $firstKey = $(az storage account keys list --resource-group $resourceGroup --account-name $accountName | convertfrom-json)[0].value

    $url = az storage blob generate-sas `
        --account-name $accountName `
        --account-key $firstKey `
        --container-name $containerName `
        --name $blobName `
        --permissions r `
        --full-uri `
        --https-only `
        --expiry $expiry  -o tsv

    # $blobUrl = az storage blob url `
    #     --account-name $accountName `
    #     --container-name $containerName `
    #     --name $blobName -o tsv

    # $url = -join ($blobUrl, "?", $blobSas)
    return $url
}


#GetBlobUrl -resourceGroup $deployResourceGroup -accountName $deployAccountName -containerName $deployContainerName -blobName $queueFunctionPackage -expiry $expiry
