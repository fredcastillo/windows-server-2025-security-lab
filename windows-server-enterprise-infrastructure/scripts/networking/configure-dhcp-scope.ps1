# Windows Server Enterprise Infrastructure
# DHCP scope configuration
#
# Review all values before running this script.
# The script is intended for the laboratory environment documented in this repository.

$ScopeName  = "Laboratorio-VMnet2"
$ScopeId    = "192.168.200.0"
$StartRange = "192.168.200.100"
$EndRange   = "192.168.200.200"
$SubnetMask = "255.255.255.0"
$DnsServer  = "192.168.200.2"
$DnsDomain  = "fred.castillo"

# Create DHCP scope
Add-DhcpServerv4Scope `
    -Name $ScopeName `
    -StartRange $StartRange `
    -EndRange $EndRange `
    -SubnetMask $SubnetMask

# Configure DNS options
Set-DhcpServerv4OptionValue `
    -ScopeId $ScopeId `
    -DnsServer $DnsServer `
    -DnsDomain $DnsDomain

Write-Host "DHCP scope configured successfully." -ForegroundColor Green
