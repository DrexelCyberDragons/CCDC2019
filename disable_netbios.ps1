$key = "HKLM:SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces"
Get-ChildItem $key |
foreach { Set-ItemProperty -Path "$key\$($_.pschildname)" -Name NetbiosOptions -Value 2 -Verbose}
