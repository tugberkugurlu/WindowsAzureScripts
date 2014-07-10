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
    Select-AzureSubscription -SubscriptionName $AzureConnectionName
}