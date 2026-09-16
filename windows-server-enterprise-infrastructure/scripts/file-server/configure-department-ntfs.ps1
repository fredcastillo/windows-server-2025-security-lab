# Windows Server Enterprise Infrastructure
# NTFS permissions for department folders

$Root = "D:\Departamentos"

$Departments = @{
    "Administrativa" = "GG_Administrativa"
    "Comunicaciones" = "GG_Comunicaciones"
    "GestionHumana"  = "GG_GestionHumana"
    "Legal"          = "GG_Legal"
    "Tecnologia"     = "GG_Tecnologia"
}

foreach ($Item in $Departments.GetEnumerator()) {

    $Department = $Item.Key
    $Group      = $Item.Value
    $Path       = Join-Path $Root $Department

    # Stop inherited permissions
    icacls $Path /inheritance:r

    # Department group
    icacls $Path /grant "FRED\$Group:(OI)(CI)(F)"

    # Administrative/system access
    icacls $Path /grant "FRED\Domain Admins:(OI)(CI)(F)"
    icacls $Path /grant "SYSTEM:(OI)(CI)(F)"

    Write-Host "Configured NTFS permissions: $Department" -ForegroundColor Green
}
