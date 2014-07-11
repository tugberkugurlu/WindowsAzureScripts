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

    ## Get storage account to take the blobs from and its context
    $storageAccountToTakeBackupFrom = Get-AzureStorageAccount -StorageAccountName $StorageAccountNameToTakeBackupFrom
    $storageAccountToTakeBackupFromCreds = $storageAccountToTakeBackupFrom | Get-AzureStorageKey
    Write-Output "Cred of $($StorageAccountNameToTakeBackupFrom): $($storageAccountToTakeBackupFromCreds.Primary)"
    $storageAccountToTakeBackupFromCtx = New-AzureStorageContext `
        -StorageAccountName $StorageAccountNameToTakeBackupFrom `
        -StorageAccountKey $storageAccountToTakeBackupFromCreds.Primary

    ## Get storage account to take the blobs to
    $storageAccountToTakeBackupTo = Get-AzureStorageAccount -StorageAccountName $StorageAccountNameToTakeBackupTo
    $storageAccountToTakeBackupToCreds = $storageAccountToTakeBackupTo | Get-AzureStorageKey
    Write-Output "Cred of $($StorageAccountNameToTakeBackupTo): $($storageAccountToTakeBackupToCreds.Primary)"
    $storageAccountToTakeBackupToCtx = New-AzureStorageContext `
        -StorageAccountName $StorageAccountNameToTakeBackupTo `
        -StorageAccountKey $storageAccountToTakeBackupToCreds.Primary

    $storageAccountToTakeBackupFromCtx | Get-AzureStorageContainer |

        foreach {

            Write-Output "$([Environment]::NewLine)"
            Write-Output "=========== Container: $($_.Name) ==========="
            Write-Output "Backup started for container '$($_.Name)' on storage account '$($_.StorageAccountName)'"

            $blobs = $_ | Get-AzureStorageBlob -Context $storageAccountToTakeBackupFromCtx -MaxCount 10
            $cToken = ($blobs | select -Last 1).ContinuationToken

            Write-Output "Retrieved $($blobs.Length) blobs from container '$($_.Name)' on storage account '$($_.StorageAccountName)'"

            ## process the first set of blobs here...
            foreach($blob in $blobs)
            {
                Write-Output "Found blob '$($blob.Name)' inside container '$($_.Name)' on storage account $($_.StorageAccountName). Backup started for this blob."
            }

            while($cToken -ne $null) {

                $nextBlobs = $_ | Get-AzureStorageBlob -Context $storageAccountToTakeBackupFromCtx -MaxCount 10 -ContinuationToken $cToken
                $cToken = ($nextBlobs | select -Last 1).ContinuationToken
                
                Write-Output "Retrieved next $($nextBlobs.Length) blobs from container '$($_.Name)' on storage account '$($_.StorageAccountName)'"

                ## process the first set of blobs here...
                foreach($blob in $blobs)
                {
                    Write-Output "Found blob '$($blob.Name)' inside container '$($_.Name)' on storage account $($_.StorageAccountName). Backup started for this blob."
                }
            }
        }
}