# Windows Server Enterprise Infrastructure
# Folder Redirection validation

$User = $env:USERNAME
$RedirectedPath = "\\WIN-IORAFMP55C9\Usuarios$\$User\Documents"

Write-Host "Current user: $User" -ForegroundColor Cyan
Write-Host "Expected redirected path: $RedirectedPath"

Write-Host "`n=== Path Test ===" -ForegroundColor Cyan
Test-Path $RedirectedPath

if (Test-Path $RedirectedPath) {
    Write-Host "Folder Redirection path is accessible." -ForegroundColor Green
}
else {
    Write-Host "Folder Redirection path was not found." -ForegroundColor Yellow
}
