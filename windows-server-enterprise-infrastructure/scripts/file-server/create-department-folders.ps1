# Windows Server Enterprise Infrastructure
# Department folder structure

$Root = "D:\Departamentos"

$Departments = @(
    "Administrativa",
    "Comunicaciones",
    "GestionHumana",
    "Legal",
    "Tecnologia"
)

New-Item `
    -Path $Root `
    -ItemType Directory `
    -Force | Out-Null

foreach ($Department in $Departments) {

    $Path = Join-Path $Root $Department

    New-Item `
        -Path $Path `
        -ItemType Directory `
        -Force | Out-Null

    Write-Host "Created: $Path" -ForegroundColor Green
}
