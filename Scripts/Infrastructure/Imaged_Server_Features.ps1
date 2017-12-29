import-module webadministration

$MasterSrv = Read-Host -Prompt 'Input a Server to image'
$SecondarySrv =  Read-Host -Prompt 'Input a Secondary Server to image too'

# Display all installed features
Invoke-Command -ComputerName $MasterSrv -ScriptBlock {get-windowsfeature | where-object {$_.Installed -eq $true}} | format-list DisplayName

# Import all installed features and sub-features to an xml file
Invoke-Command -ComputerName $MasterSrv -ScriptBlock {Get-WindowsFeature} | ? { $_.Installed -AND $_.SubFeatures.Count -eq 0 } | Export-Clixml c:\ServerFeatures.xml

# Install featues from the master server to the secondary server

Invoke-Command -ComputerName $SecondarySrv -ScriptBlock {$ServerFeatures = Import-Clixml c:\ServerFeatures.xml}
	foreach ($feature in $ServerFeatures) 
			{
				Install-WindowsFeature -Name $feature.name
			}
