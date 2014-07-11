workflow Backup-BlobStorage {

    param (

        [parameter(Mandatory=$true)]
        [String]
        $AzureConnectionName,

        [parameter(Mandatory=$true)]
        [String]
        $StorageAccountNameToTakeBackupFrom,

        [parameter(Mandatory=$true)]
        [String]
        $StorageAccountNameToTakeBackupTo
    )

    Connect-Azure -AzureConnectionName $AzureConnectionName
    Select-AzureSubscription -SubscriptionName $AzureConnectionName -Default

    InlineScript {
        
        ## Get storage account to take the blobs from and its context
        $storageAccountToTakeBackupFrom = Get-AzureStorageAccount -StorageAccountName $Using:StorageAccountNameToTakeBackupFrom
        $storageAccountToTakeBackupFromCreds = $storageAccountToTakeBackupFrom | Get-AzureStorageKey
        $storageAccountToTakeBackupFromCtx = New-AzureStorageContext `
            -StorageAccountName $Using:StorageAccountNameToTakeBackupFrom `
            -StorageAccountKey $storageAccountToTakeBackupFromCreds.Primary
        
        ## Get storage account to take the blobs to
        $storageAccountToTakeBackupTo = Get-AzureStorageAccount -StorageAccountName $Using:StorageAccountNameToTakeBackupTo
        $storageAccountToTakeBackupToCreds = $storageAccountToTakeBackupTo | Get-AzureStorageKey
        $storageAccountToTakeBackupToCtx = New-AzureStorageContext `
            -StorageAccountName $StorageAccountNameToTakeBackupTo `
            -StorageAccountKey $storageAccountToTakeBackupToCreds.Primary

        $storageAccountToTakeBackupFromCtx | Get-AzureStorageContainer |

            foreach {

                Write-Output "=========== Container: $($_.Name) ==========="
                Write-Output "Backup started for container '$($_.Name)' on storage account '$($_.StorageAccountName)'"

                $total = 0
                $token = $null

                do
                {
                    $blobs = $_ | Get-AzureStorageBlob -Context $storageAccountToTakeBackupFromCtx -MaxCount 10 -ContinuationToken $token
                    $total += $blobs.Length
                    $token = ($blobs | select -Last 1).ContinuationToken
                
                    Write-Output "Retrieved next $($blobs.Length) blobs from container '$($_.Name)' on storage account '$($_.StorageAccountName)'"

                    ## process the first set of blobs here...
                    foreach($blob in $blobs)
                    {
                        Write-Output "Found blob '$($blob.Name)' inside container '$($_.Name)' on storage account $($_.StorageAccountName). Backup started for this blob."
                    }
                }
                while($token -ne $null)

                Write-Output "Done processing container '$($_.Name)'"
                Write-Output "$([Environment]::NewLine)"
            }
    }
}