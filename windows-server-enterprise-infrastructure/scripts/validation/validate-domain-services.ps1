# Windows Server Enterprise Infrastructure
# Domain service validation

Write-Host "=== Domain Controller Discovery ===" -ForegroundColor Cyan
nltest /dsgetdc:fred.castillo

Write-Host "`n=== DNS ===" -ForegroundColor Cyan
nslookup fred.castillo

Write-Host "`n=== Time Service ===" -ForegroundColor Cyan
w32tm /query /status

Write-Host "`n=== Active Directory Policy ===" -ForegroundColor Cyan
Get-ADDefaultDomainPasswordPolicy
