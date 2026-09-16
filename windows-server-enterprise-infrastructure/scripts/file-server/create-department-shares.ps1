# Windows Server Enterprise Infrastructure
# SMB department shares

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

    New-SmbShare `
        -Name $Department `
        -Path $Path `
        -ChangeAccess "FRED\$Group" `
        -FullAccess "FRED\Domain Admins"

    Write-Host "Created SMB share: $Department" -ForegroundColor Green
}
