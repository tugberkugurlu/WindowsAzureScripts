#http://michaelwasham.com/2012/06/08/automating-windows-azure-virtual-machines-with-powershell/
##Uncoment all the below code and change the variables

$subscriptionId = ''
$currentStorageAccounName = ''
$affinityGroupName = ''
$cloudSvcName = ''
$vmName = ''
$imageName = 'MSFT__Windows-Server-2012-Datacenter-201208.01-en.us-30GB.vhd'
$adminPassword = ''
$subscriptionName = (Get-AzureSubscription | where { $_.SubscriptionId -eq $subscriptionId }).SubscriptionName

Get-AzureSubscription | where { $_.SubscriptionId -eq $subscriptionId } | Select-AzureSubscription
Set-AzureSubscription -SubscriptionId $subscriptionId -SubscriptionName $subscriptionName -CurrentStorageAccount $currentStorageAccounName
New-AzureQuickVM -Windows -ServiceName $cloudSvcName -Name $vmName -ImageName $imageName -Password $adminPassword -AffinityGroup $affinityGroupName