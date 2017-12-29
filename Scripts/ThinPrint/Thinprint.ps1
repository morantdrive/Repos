# Import AD Module
Import-module Activedirectory

# Script to gather all disabled accounts in APEX domain and write them to a file
$ADAPEX = (Get-ADUser -Filter * -SearchBase "DC=APEX,DC=com" -Properties * | Where-Object {$_.Enabled -eq $false} )
$ADAPEX | Select-Object SAMAccountName,SID,Enabled,Displayname | Export-Csv -Path C:\Allusers.txt -NoTypeInformation

# Script to store credentials
$mycred = Get-Credential


# A ScriptBlock variable created for remote execution
	$Workload = 
          {
              Import-Module TPPowershell
              Connect-tp http://axgw1:4004 -PSCredential $mycred
              Update-TPUser $SID -Disable
              }  

# Script to remote execute on Thinprint Server for disabling account
	ForEach ($ADuser in $ADAPEX)
        {
        $SID = $ADuser.SID.Value
       Invoke-command -Computername axgw1 -Credential $mycred -ScriptBlock { $Workload }            
       Import-Module TPPowershell
          Connect-tp http://axgw1:4004 -PSCredential $mycred
          Update-TPUser $SID -Disable 
          $ADUser | Select-Object Displayname,SID | Out-file C:\Users\Public\Documents\thinprintuser.txt
             }

