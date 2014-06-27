New-AzureStorageContainer -Name 'jhgfrefe' -Permission Off
Set-AzureStorageBlobContent -Container 'jhgfrefe' -File 'E:\WAPS\image.gif' -Blob 'myimage.gif'

Set-AzureStorageContainerAcl -Name 'jhgfrefe' -Permission Blob