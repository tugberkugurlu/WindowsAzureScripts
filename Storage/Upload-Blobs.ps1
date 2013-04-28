########################################################################################
## Samples: 
##          ls -File -Recurse | Set-AzureStorageBlobContent -Container upload
##          $meta = @{"key" = "value"; "name" = "test"}
##          Set-AzureStorageBlobContent -File filename -Container containername -Metadata $meta
##          Get-AzureStorageContainer -Container container* | Set-AzureStorageBlobContent -File filename -Blob blobname
## Files: 
##          SetAzureStorageBlobContent.cs
##          https://github.com/WindowsAzure/azure-sdk-tools/blob/master/WindowsAzurePowershell/src/Management.Storage/Blob/Cmdlet/SetAzureStorageBlobContent.cs
## Ref: 
##          http://blogs.msdn.com/b/webdev/archive/2013/02/14/getting-a-mime-type-from-a-file-extension-in-asp-net-4-5.aspx
########################################################################################

param(
    [Parameter(Mandatory = $true)][String]$directoryPath,
    [Parameter(Mandatory = $true)][String]$containerName
)

[System.Reflection.Assembly]::LoadWithPartialName("System.Web") | Out-Null
$container = Get-AzureStorageContainer -Name $containerName -Verbose

Get-ChildItem -Path $directoryPath -File | foreach {
    
    $props = @{ 'ContentType' = [System.Web.MimeMapping]::GetMimeMapping($_.Name) }
    $container | Set-AzureStorageBlobContent -Properties $props -File $_.FullName -Verbose
}