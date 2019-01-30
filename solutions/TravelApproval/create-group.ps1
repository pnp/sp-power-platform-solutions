Write-Host 'Connecting to Office 365 PowerShell' -ForegroundColor Yellow 
$O365Cred = Get-Credential 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $O365cred -Authentication Basic -AllowRedirection 
Write-Host 'Connection to Office 365 Successful' -ForegroundColor Yellow 
Write-Host 'Importing Office 365 PSSession' -ForegroundColor Yellow 
Import-PSSession $Session -DisableNameChecking |Out-Null 
Write-Host 'PSSession Importing has been Completed' -ForegroundColor Green

$approvalGroup = 'Travel Group Approver'
$approver = Get-UnifiedGroup |Where-Object {$_.DisplayName -eq $approvalGroup}

if ($null -eq $approver){
    Write-Host "Creating group $approvalGroup ..."
    $approver = New-UnifiedGroup -DisplayName "Travel Group Approver"
}

Write-Host "$approvalGroup info"
$approver | Format-List -Property "ExternalDirectoryObjectId","PrimarySmtpAddress","DisplayName"

Remove-PSSession $Session