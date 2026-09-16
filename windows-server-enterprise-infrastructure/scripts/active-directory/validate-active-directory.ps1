# Windows Server Enterprise Infrastructure
# Active Directory validation

Write-Host "=== Domain ===" -ForegroundColor Cyan
Get-ADDomain

Write-Host "`n=== Organizational Units ===" -ForegroundColor Cyan
Get-ADOrganizationalUnit -Filter *

Write-Host "`n=== Security Groups ===" -ForegroundColor Cyan
Get-ADGroup -Filter "Name -like 'GG_*'"

Write-Host "`n=== Password and Lockout Policy ===" -ForegroundColor Cyan
Get-ADDefaultDomainPasswordPolicy
