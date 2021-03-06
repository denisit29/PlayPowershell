#Set-MTU.ps1
# Author: Kurt De Greeff
param([int] $MTUSize = 1476)
#param([int] $MTUSize = $(throw "usage: ./Set-MTU <MTU Size>"))

function SetProperty([string]$path, [string]$key, [string]$Value) {
$oldValue = (Get-ItemProperty -path $path).$key
Set-ItemProperty -path $path -name $key -Type DWORD -Value $Value
$newValue = (Get-ItemProperty -path $path).$key
$data =  "$path\$key=$oldValue" 
Write-Output "Value for $path\$key changed from $oldValue to $newValue"
}

#Interfaces\<adapter ID>\MTU -> 1450-1500, test for maximum value that will pass on each interface using PING -f -l <MTU Size> <Interface Gateway Address>
$RegistryEntries = Get-ItemProperty -path "HKLM:\system\currentcontrolset\services\tcpip\parameters\interfaces\*"
foreach ( $iface in $RegistryEntries ) { 
$ip = $iface.DhcpIpAddress
if ( $ip -ne $null ) { $childName = $iface.PSChildName}
else {
$ip = $iface.IPAddress
if ($ip -ne $null) { $childName = $iface.PSChildName }
}
$Interface = Get-ItemProperty -path "HKLM:\system\currentcontrolset\services\tcpip\parameters\interfaces\$childName"
$path = $Interface.PSPath
SetProperty $path MTU $MTUSize
}