# http://www.itq.nl/blogs/post/Walkthrough-Hosting-FTP-on-IIS-75-in-Windows-Azure-VM.aspx

$subscriptionId = ''

function pad($val) { 

    if($val -ge 10) { 
        return "$val";
    }

    return ("{0}$val" -f 0)
}

Get-AzureSubscription | where { $_.SubscriptionId -eq $subscriptionId } | Select-AzureSubscription

Get-AzureVM -ServiceName tgbrkvms -Name IIS1-08R2 | Add-AzureEndpoint -Name 'FTPCommand' -Protocol 'TCP' -LocalPort 21 -PublicPort 21 | Update-AzureVM
Get-AzureVM -ServiceName tgbrkvms -Name IIS1-08R2 | Add-AzureEndpoint -Name 'FTPData' -Protocol 'TCP' -LocalPort 20 -PublicPort 20 | Update-AzureVM
for ($i=1; $i -le 15; $i++) { 

    Write-Host ('FTPPassive{0}' -f (pad $i)) '-' ('70{0}' -f (pad $i))
    Get-AzureVM -ServiceName tgbrkvms -Name IIS1-08R2 | Add-AzureEndpoint -Name ('FTPPassive{0}' -f (pad $i)) -Protocol 'TCP' -LocalPort ('70{0}' -f (pad $i)) -PublicPort ('70{0}' -f (pad $i)) | Update-AzureVM
}