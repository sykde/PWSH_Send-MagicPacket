<#
    This script displays a list of MAC addresses from a json file,
    prompts the user to decide whether to pick one of the
    existing addresses or provide their own input and then
    broadcasts a WOL package for the chosen computer in port 0.
#>

$knownAdaptors = Get-Content -Path $env:HOMEPATH\.config\WakeOnLAN\targetsList.json -ErrorAction SilentlyContinue | ConvertFrom-Json

Write-Host @"

List of known hosts:

"@

$count = 0

foreach ($adaptor in $knownAdaptors)
{
    Write-Host "[$count]>" $adaptor.MAC "`t Friendly Name: " $adaptor.friendlyName
    $count += 1
}

Write-Host @"
[$count]> User-defined

"@

Write-Host -NoNewline "Choose target of Magic Package: "
[Int16] $target = Read-Host

if ($targetMac -eq $count)
{
    Write-Host -NoNewline "MAC of target: "
    $targetAdaptor = Read-Host
}
elseif (($target -gt $count) -or ($target -lt 0))
{
    throw "Invalid input value"
}
else
{
    [PSCustomObject] $targetAdaptor = $knownAdaptors[$target]
}

# Create WOL package contents:

[Byte[]] $startBytes = ,0xFF * 6

$targetAdaptor.MAC = $targetAdaptor.MAC.Replace(':','-')
[Byte[]] $macBytes = ($targetAdaptor.MAC.Split('-') | ForEach-Object { [Byte] "0x$_"}) * 16

[Byte[]] $magicPacketContents = $startBytes + $macBytes

# Send WOL package:

$UdpClient = New-Object System.Net.Sockets.UdpClient
$UdpClient.Connect([System.Net.IPAddress]::Broadcast,0)
$UdpClient.Send($magicPacketContents, $magicPacketContents.Length) | Out-Null #Suppress Output
$UdpClient.Close()
