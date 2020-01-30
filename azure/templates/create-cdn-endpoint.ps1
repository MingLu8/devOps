$userPrinciple = Get-AzADUser -UserPrincipalName mclu@asicentral.com | Select-Object -ExpandProperty Id
$functionPackageUri = "https://asideploymentstorage.blob.core.windows.net/deployments/webp/webp/publish.zip?sp=r&st=2020-01-30T05:48:32Z&se=2021-01-30T13:48:32Z&spr=https&sv=2019-02-02&sr=b&sig=lPpnWIQmOEhU9Voh4KRt0xZROcWjJRtIprIs9jd42As%3D"
$resourceGroup = "deploy-webp-group-ming11"
$location = "East US"
$templateFile = ".\create-cdn-endpoint.json"
#$templateParameterFile = ".\keyvaultdeploy.parameters.json"
#$keyVaultName = "webpsamplevault"
$templateBaseUrl = "https://raw.githubusercontent.com/MingLu8/devOps/master/azure"
$cdnEndpointName = "samplecdn"
$cdnEndPointOrigin = "func-app-v6vxfwotr3rzi.azurewebsites.net"
$functionKey = "sadfasdf"                                    
#Remove-AzResourceGroup -Name sample -Force

Get-AzResourceGroup -Name $resourceGroup -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent) {
    New-AzResourceGroup -Name $resourceGroup -Location $location
}
  
New-AzResourceGroupDeployment `
    -Name createDeployment3 `
    -ResourceGroupName $resourceGroup `
    -TemplateFile $templateFile `
    -cdnEndPointOrigin $cdnEndPointOrigin `
    -functionKey $functionKey `
    -cdnEndpointName $cdnEndpointName `
    -debug