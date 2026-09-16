# Windows Server Enterprise Infrastructure
# SMB troubleshooting validation

$Server = "WIN-IORAFMP55C9"
$Share  = "Administrativa"
$UNC    = "\\$Server\$Share"

Write-Host "=== Identity ===" -ForegroundColor Cyan
whoami
whoami /groups

Write-Host "`n=== Kerberos ===" -ForegroundColor Cyan
klist

Write-Host "`n=== UNC Resource ===" -ForegroundColor Cyan
Test-Path $UNC

Write-Host "`n=== Share Permissions ===" -ForegroundColor Cyan
Get-SmbShareAccess -Name $Share

Write-Host "`n=== SMB Session ===" -ForegroundColor Cyan
Get-SmbSession

Write-Host "`n=== Open Files ===" -ForegroundColor Cyan
Get-SmbOpenFile

Write-Host "`n=== Network Port ===" -ForegroundColor Cyan
Test-NetConnection $Server -Port 445

Write-Host "`n=== Directory Contents ===" -ForegroundColor Cyan
Get-ChildItem $UNC
