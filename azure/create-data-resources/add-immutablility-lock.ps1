param (
    [Parameter(Mandatory = $true)][string] $ResourceGroupName,
    [Parameter(Mandatory = $true)][string] $StorageAccountName,
    $immutabilityPeriod = 1,
    $containerName = "originals"
)

$legalHoldTag = "$StorageAccountName$containerName"

Add-AzRmStorageContainerLegalHold `
    -ResourceGroupName $ResourceGroupName `
    -StorageAccountName $StorageAccountName `
    -Name $containerName -Tag $legalHoldTag

Set-AzRmStorageContainerImmutabilityPolicy `
    -ResourceGroupName $ResourceGroupName `
    -StorageAccountName $StorageAccountName `
    -ContainerName $containerName `
    -ImmutabilityPeriod $ImmutabilityPeriod `

$policy = Get-AzRmStorageContainerImmutabilityPolicy `
    -ResourceGroupName $ResourceGroupName `
    -StorageAccountName $StorageAccountName `
    -ContainerName $containerName
 
Lock-AzRmStorageContainerImmutabilityPolicy -ImmutabilityPolicy $policy -force