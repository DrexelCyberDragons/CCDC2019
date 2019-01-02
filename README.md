# CCDC2019


Seatbelt, Sharpup (Compiled for .NET 3.5)

PowerShellMafia PrivEsc scripts


Disable Netbios:

$key = "HKLM:SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces"
Get-ChildItem $key |
foreach { Set-ItemProperty -Path "$key\$($_.pschildname)" -Name NetbiosOptions -Value 2 -Verbose}
