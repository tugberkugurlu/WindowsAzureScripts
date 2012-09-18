#more info: http://msdn.microsoft.com/en-us/library/windowsazure/gg432987

makecert -r -pe -n "CN=AzureMgmt2" -a sha1 -len 2048 -ss My "AzureMgmt2.cer"