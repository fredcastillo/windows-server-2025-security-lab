# Windows Server Enterprise Infrastructure
# Network validation

Write-Host "=== IP Configuration ===" -ForegroundColor Cyan
ipconfig /all

Write-Host "`n=== Domain Controller Discovery ===" -ForegroundColor Cyan
nltest /dsgetdc:fred.castillo

Write-Host "`n=== DNS Resolution ===" -ForegroundColor Cyan
nslookup fred.castillo

Write-Host "`n=== SMB Connectivity ===" -ForegroundColor Cyan
Test-NetConnection WIN-IORAFMP55C9 -Port 445
