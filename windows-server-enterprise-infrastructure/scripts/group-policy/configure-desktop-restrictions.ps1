# Windows Server Enterprise Infrastructure
# Desktop restriction registry settings
#
# These settings represent the configuration used by:
# "Restricciones Escritorio - 4 Direcciones"

# Explorer restrictions
$ExplorerPolicy = `
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"

New-Item `
    -Path $ExplorerPolicy `
    -Force | Out-Null

Set-ItemProperty `
    -Path $ExplorerPolicy `
    -Name "NoControlPanel" `
    -Type DWord `
    -Value 1

Set-ItemProperty `
    -Path $ExplorerPolicy `
    -Name "NoRun" `
    -Type DWord `
    -Value 1

# Command Prompt restriction
$SystemPolicy = `
    "HKCU:\Software\Policies\Microsoft\Windows\System"

New-Item `
    -Path $SystemPolicy `
    -Force | Out-Null

Set-ItemProperty `
    -Path $SystemPolicy `
    -Name "DisableCMD" `
    -Type DWord `
    -Value 2

Write-Host "Desktop restriction settings configured." -ForegroundColor Green
