
# Set execution policy
powershell Set-ExecutionPolicy RemoteSigned

# Import modules
If (!(Get-module Azure))
	{
		Import-Module Azure
	}
If (!(Get-module AzureRM))
	{
		Import-Module AzureRM
	}

# Login to the azure account
Clear-Variable -Name rmContext -ErrorAction SilentlyContinue
$rmContext = Get-AzureRmContext -ErrorAction SilentlyContinue
If (!($rmContext.Environment))
    {
        Login-AzureRmAccount
    }

$IISServer = Read-Host -Prompt 'Input a Web Server name'
$IIS = "Installed"

# Get Windows Feature
$wf = Invoke-Command -ComputerName $IISServer -ScriptBlock {get-windowsfeature}
#$IISInstall = $wf.InstallState

ForEach ($WebInstall in $wf)
 {
    If ($WebInstall.Name -eq 'Web-Server'  -and $WebInstall.InstallState -eq 'Installed')
        {
        $IIS = $WebInstall.Name
        }
    }

If ($IIS -ne "Web-Server" )
    {
        Write-Host 'IIS is installing on' 
        $IISServer
        Invoke-Command -ComputerName $IISServer -ScriptBlock {Add
        -windowsfeature -name web-server}
    }
Else
    {
        Write-Host 'IIS is installed'
        }