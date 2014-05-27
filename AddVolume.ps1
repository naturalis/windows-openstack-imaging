$d = Get-Disk | where {$_.OperationalStatus -eq "Offline" -and $_.PartitionStyle -eq 'raw'}
$d | Set-Disk -IsOffline $false
$d | Initialize-Disk -PartitionStyle MBR
$p = $d | New-Partition -UseMaximumSize -DriveLetter "E"
$p | Format-Volume -FileSystem NTFS -NewFileSystemLabel "Volume1" -Confirm:$false
