####################################################
## http://michaelwasham.com/2012/06/08/automating-windows-azure-virtual-machines-with-powershell/
####################################################

param(
    [Parameter(Mandatory = $true)][String]$subscriptionId,
    [Parameter(Mandatory = $true)][String]$affinityGroupName,
    [Parameter(Mandatory = $true)][String]$diskName,
    [Parameter(Mandatory = $true)][String]$adminPassword,
    [Parameter(Mandatory = $true)][String]$serviceName,
    [Parameter(Mandatory = $true)][String]$vmName,
    [ValidateSet('ExtraSmall', 'Small', 'Medium', 'Large', 'ExtraLarge')]
    [Parameter(Mandatory = $true)][String]$instanceSize,
    [Parameter(Mandatory = $true)][Int32]$remoteDesktopPublicPort
)

# Variables
$endpoints = @(@('RemoteDesktop', 3389, $remoteDesktopPublicPort), @('WebDeploy', 8172, 8172), @('Web', 80, 80))
$deploymentLabel = "$((get-date).ToString("MMM dd @ HHmm"))"
$deploymentName = "$((get-date).ToString("yyyyMMddHHmmss"))-auto"

# Select the Subscription
Get-AzureSubscription | where { $_.SubscriptionId -eq $subscriptionId  } | Select-AzureSubscription

$vm = New-AzureVMConfig -Name $vmName -InstanceSize $instanceSize -DiskName $diskName |
      # As we are creating the VM through an OS Disk, ProvisioningConfigurationSet cannot be present
      # Add-AzureProvisioningConfig -Windows -Password $adminPassword |
      % { 
          foreach($endpoint in $endpoints) { 
            $_ | Add-AzureEndpoint -Name "$($endpoint[0])" -Protocol TCP -LocalPort $endpoint[1] -PublicPort $endpoint[2] | Out-Null
          }

          return $_
      }

New-AzureVM -ServiceName $serviceName -VMs $vm -AffinityGroup $affinityGroupName -DeploymentLabel $deploymentLabel -DeploymentName $deploymentName