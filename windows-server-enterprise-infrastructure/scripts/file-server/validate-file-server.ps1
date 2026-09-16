# Windows Server Enterprise Infrastructure
# File Server validation

$Departments = @(
    "Administrativa",
    "Comunicaciones",
    "GestionHumana",
    "Legal",
    "Tecnologia"
)

foreach ($Department in $Departments) {

    Write-Host "`n=== $Department ===" -ForegroundColor Cyan

    $SharePath = "\\WIN-IORAFMP55C9\$Department"

    Write-Host "Share:"
    Get-SmbShare -Name $Department -ErrorAction SilentlyContinue

    Write-Host "Access:"
    Get-SmbShareAccess `
        -Name $Department `
        -ErrorAction SilentlyContinue

    Write-Host "Path test:"
    Test-Path $SharePath
}
