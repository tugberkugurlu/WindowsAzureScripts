##################################################
#
##################################################

param(
    [Parameter(Mandatory = $true)][String]$subscriptionId,
    [Parameter(Mandatory = $true)][String]$storageAccountName,
    [Parameter(Mandatory = $true)][String]$affinityGroupName,
    [Parameter(Mandatory = $true)][String]$imageName = 'MSFT__Windows-Server-2012-Datacenter-201208.01-en.us-30GB.vhd',
    [Parameter(Mandatory = $true)][String]$adminPassword,
    [Parameter(Mandatory = $true)][String]$serviceName,
    [Parameter(Mandatory = $true)][String]$vmName,
    [ValidateSet('ExtraSmall', 'Small', 'Medium', 'Large', 'ExtraLarge')]
    [Parameter(Mandatory = $true)][String]$instanceSize
)

# Variables
$endpoints = @(@('WebDeploy', 8172, 8172), @('Web', 80, 80))
$subscriptionName = (Get-AzureSubscription | where { $_.SubscriptionId -eq $subscriptionId }).SubscriptionName

# Select the Subscription
Get-AzureSubscription | where { $_.SubscriptionId -eq $subscriptionId  } | Select-AzureSubscription

# Set CurrentStorageAccount
Set-AzureSubscription -SubscriptionId $subscriptionId -SubscriptionName $subscriptionName -CurrentStorageAccount $storageAccountName

# Create a New VM
New-AzureQuickVM -Windows -ServiceName $serviceName -Name $vmName -ImageName $imageName -Password $adminPassword -AffinityGroup $affinityGroupName -InstanceSize $instanceSize

# Add Azure Endpoints
foreach($endpoint in $endpoints) { 

    Get-AzureVM -ServiceName $serviceName -Name $vmName | Add-AzureEndpoint -Name "$($endpoint[0])" -Protocol TCP -LocalPort $endpoint[1] -PublicPort $endpoint[2] | Update-AzureVM
}