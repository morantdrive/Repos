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

$targetServer = Read-Host -Prompt 'Input a Web Server Name' 
$targetwebsite = Read-Host -Prompt 'Input Website Name'

Invoke-Command -ComputerName $targetServer -ScriptBlock {
    (import-module WebAdministration);
    Stop-Website -Name $targetwebsite;
    } 

