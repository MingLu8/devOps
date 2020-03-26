$ResourceGroupName = "mclu-image-service-data"
$StorageAccountName = "mcluwebpdev4"
$containerName = "originals"
$legalHoldTag = "$StorageAccountName$containerName"

Add-AzRmStorageContainerLegalHold `
    -ResourceGroupName $ResourceGroupName `
    -StorageAccountName $StorageAccountName `
    -Name $containerName -Tag $legalHoldTag

Set-AzRmStorageContainerImmutabilityPolicy `
    -ResourceGroupName $ResourceGroupName `
    -StorageAccountName $StorageAccountName `
    -ContainerName $containerName `
    -ImmutabilityPeriod 1

$policy = Get-AzRmStorageContainerImmutabilityPolicy `
    -ResourceGroupName $ResourceGroupName `
    -StorageAccountName $StorageAccountName `
    -ContainerName $containerName
 
Lock-AzRmStorageContainerImmutabilityPolicy -ImmutabilityPolicy $policy -force