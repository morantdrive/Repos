
# This is a script to gather all servers with disk less than 20% of space left

# Import servers too query
$server = get-content c:\testlist.txt

# Gather disk inventory
$disks = get-wmiobject -class "Win32_LogicalDisk" -Filter "Drivetype=3" -computername $server
$perct = 20

#Filter out all servers with disk space less than a certain percent
$results = foreach ($disk in $disks)
{
    if ($disk.Size -gt 0)
    {
        $size = [math]::round($disk.Size/1GB, 0)
        $free = [math]::round($disk.FreeSpace/1GB, 0)
        [PSCustomObject]@{
            Drive = $disk.Name
            Name = $disk.SystemName
            "Total Disk Size" = $size
            "Free Disk Size" = "{0:N0} ({1:P0})" -f $free, ($free/$size)                  }
        If ((($free/$size) * 100) -lt $perct)
         {
           write-host $disk.systemname, $disk.name "is below 20% capacity", $free"gb free"
           write-eventlog -LogName Application -Source "Disk Space Warning" -EntryType Warning -EventId 911 -Message "$disk.systemname is below 20% capacity $freegb free"
         }
        Else
        {
           write-host "No error found"
        }    
    }
}
#  Display and write outputs
$results | Out-GridView
$results | Format-Table -AutoSize
$results | Export-Csv -Path c:\disks.csv -NoTypeInformation -Encoding ASCII
