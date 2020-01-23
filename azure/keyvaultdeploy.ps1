$resourceGroup = "sample7"
$location = "East US"
$templateFile = ".\keyvaultdeploy.json"
$templateParameterFile = ".\keyvaultdeploy.parameters.json"
$keyVaultName = "SomeKeyVault7"

#Remove-AzResourceGroup -Name sample -Force

Get-AzResourceGroup -Name $resourceGroup -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent) {
  New-AzResourceGroup -Name $resourceGroup -Location $location
}
    
# Set-AzKeyVaultAccessPolicy -VaultName ExampleVault -EnabledForTemplateDeployment

# Get-AzKeyVault -VaultName sample -ResourceGroupName sample -ErrorVariable noVaultExists
# if($noVaultExists) {
#     New-AzKeyVault -VaultName ExampleVault -resourceGroupName $resourceGroup -Location $location -EnabledForTemplateDeployment
# }
    
# $secretvalue = ConvertTo-SecureString 'hVFkk965BuUv' -AsPlainText -Force
# $secret = Set-AzKeyVaultSecret -VaultName ExampleVault -Name 'ExamplePassword' -SecretValue $secretvalue
function GetKeyVaultAccessPolicy([string][parameter(Mandatory = $true)] $keyVaultName) {

  $keyVaultAccessPolicies = (Get-AzKeyVault -VaultName $keyVaultName).accessPolicies
  $armAccessPolicies = @()

  if ($keyVaultAccessPolicies) {
    foreach ($keyVaultAccessPolicy in $keyVaultAccessPolicies) {
      $armAccessPolicy = [pscustomobject]@{
        tenantId = $keyVaultAccessPolicy.TenantId
        objectId = $keyVaultAccessPolicy.ObjectId
      }

      $armAccessPolicyPermissions = [pscustomobject]@{
        keys         = $keyVaultAccessPolicy.PermissionsToKeys
        secrets      = $keyVaultAccessPolicy.PermissionsToSecrets
        certificates = $keyVaultAccessPolicy.PermissionsToCertificates
        storage      = $keyVaultAccessPolicy.PermissionsToStorage
      }

      $armAccessPolicy | Add-Member -MemberType NoteProperty -Name permissions -Value $armAccessPolicyPermissions

      $armAccessPolicies += $armAccessPolicy
    }
  }

  $armAccessPoliciesParameter = $armAccessPolicies

  $armAccessPoliciesParameter = $armAccessPoliciesParameter | ConvertTo-Json -Depth 5 -Compress

  #Write-Host ("##vso[task.setvariable variable=Infra.KeyVault.AccessPolicies;]$armAccessPoliciesParameter")
  return $armAccessPoliciesParameter
}
@(GetKeyVaultAccessPolicy $keyVaultName)
New-AzResourceGroupDeployment `
  -Name keyvaultDeploy3 `
  -ResourceGroupName $resourceGroup `
  -TemplateFile $templateFile `
  -TemplateParameterFile $templateParameterFile `
  -keyVaultName $keyVaultName `
  -Debug
