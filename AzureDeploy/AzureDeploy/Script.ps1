#

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
#
