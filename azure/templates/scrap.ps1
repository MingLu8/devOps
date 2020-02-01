# $keyVaultName = 
# az keyvault secret show --vault-name $keyVaultName --name webpFunctionKey | ConvertFrom-Json | select -ExpandProperty Id
#az group deployment create -g "deploy-webp-group-ming13" --template-file get-unique-string.json --parameters @params.json --parameters '{
#     "location": {
#         "value": "westus"
#     }
# }'

. .\helpers.ps1

$deployResourceGroup = "deploy-storage-group"
$deployAccountName = "asideploymentstorage"
$deployContainerName = "deployments"
$queueFunctionPackage = "webp/queue-function/publish.zip"
$expiry = (Get-Date).AddHours(5).ToString("yyyy-MM-dd")

# GetBlobUrl -resourceGroup $deployResourceGroup -accountName $deployAccountName -containerName $deployContainerName -blobName $queueFunctionPackage -expiry $expiry

az storage container generate-sas --account-name asideploymentstorage --name deployments --permissions acdlrw --expiry (Get-Date).AddHours(5).ToString("yyyy-MM-dd") --auth-mode login --debug
