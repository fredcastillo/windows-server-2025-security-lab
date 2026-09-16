# Windows Server Enterprise Infrastructure
# Wallpaper registry settings

$PolicyPath = `
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System"

$WallpaperPath = `
    "\\WIN-IORAFMP55C9\NETLOGON\wallpaper.jpg"

New-Item `
    -Path $PolicyPath `
    -Force | Out-Null

Set-ItemProperty `
    -Path $PolicyPath `
    -Name "Wallpaper" `
    -Value $WallpaperPath `
    -Type String

Set-ItemProperty `
    -Path $PolicyPath `
    -Name "WallpaperStyle" `
    -Value "10" `
    -Type String

Set-ItemProperty `
    -Path $PolicyPath `
    -Name "TileWallpaper" `
    -Value "0" `
    -Type String

Write-Host "Wallpaper configuration applied." -ForegroundColor Green
