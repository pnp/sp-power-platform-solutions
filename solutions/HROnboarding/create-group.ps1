Write-Host 'Connecting to Office 365 PowerShell' -ForegroundColor Yellow 
$O365Cred = Get-Credential 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $O365cred -Authentication Basic -AllowRedirection 
Write-Host 'Connection to Office 365 Successful' -ForegroundColor Yellow 
Write-Host 'Importing Office 365 PSSession' -ForegroundColor Yellow 
Try
{
    Import-PSSession $Session -DisableNameChecking  
    Write-Host 'PSSession Importing has been Completed' -ForegroundColor Green
    
    $CreateGroupsName = @('HR Department','IT Equipment Department', 'IT Department', 'Corporate Training Department')
    foreach($groupName in $CreateGroupsName){
        $group = Get-UnifiedGroup |Where-Object {$_.DisplayName -eq $groupName}
        if ($null -eq $group){
            Write-Host "Creating group $groupName ..."
            $group = New-UnifiedGroup -DisplayName $groupName
        }
        
        Write-Host "$groupName info"
        $group | Format-List -Property "ExternalDirectoryObjectId","PrimarySmtpAddress","DisplayName"
    }
}
Catch
{
    Write-Host $_
}
Finally
{
    Remove-PSSession $Session
}

