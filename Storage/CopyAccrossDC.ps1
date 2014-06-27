# Target Storage Account (East US)
$tStorageAccount = "account-name"
$tStorageKey = "account-key"
 
$fStorageAccount = 'account-key-2'
$fStorageKey = 'account-name-2'

$destContext = New-AzureStorageContext  –StorageAccountName $tStorageAccount `
                                        -StorageAccountKey $tStorageKey 

$fromContext = New-AzureStorageContext  –StorageAccountName $fStorageAccount `
                                        -StorageAccountKey $fStorageKey


# Source VHD
$srcUri = "http://<account-name>.blob.core.windows.net/vhds/foo-2012-11-08.vhd" 
 
New-AzureStorageContainer -Name 'vhds3' -Context $destContext
 
$blob = Start-AzureStorageBlobCopy -srcUri $srcUri `
                                   -Context $fromContext `
                                   -DestContainer 'vhds3' `
                                   -DestBlob "testcopy1.vhd" `
                                   -DestContext $destContext
                                     
## Get-AzureStorageBlobCopyState -Container vhds2 -Blob testcopy1.vhd
$blob | Get-AzureStorageBlobCopyState