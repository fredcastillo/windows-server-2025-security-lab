# Windows Server Enterprise Infrastructure
# Client DHCP configuration

$InterfaceAlias = "Ethernet0"

Set-NetIPInterface `
    -InterfaceAlias $InterfaceAlias `
    -Dhcp Enabled

ipconfig /release
ipconfig /renew

# Reset previous DNS configuration
Set-DnsClientServerAddress `
    -InterfaceAlias $InterfaceAlias `
    -ResetServerAddresses

Write-Host "Client DHCP configuration completed." -ForegroundColor Green
