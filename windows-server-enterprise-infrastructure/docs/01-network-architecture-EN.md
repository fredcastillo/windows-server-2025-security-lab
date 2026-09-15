# 01 — Network Architecture

## Context

The project required a functional Windows Server environment capable of providing **Active Directory, DNS, and DHCP** services to domain-joined Windows clients.

The final implementation used two network interfaces on the Windows Server:

- One interface connected to the physical network through VMware Bridged networking.
- A second interface connected to an isolated VMware Host-only network for the internal laboratory.

This separation allowed the internal project environment to operate on a private subnet while keeping physical-network connectivity available to the server when required.

---

## Network Design

The final configuration used two IPv4 networks.

### Physical Network

```text
Network: 192.168.100.0/24
Gateway: 192.168.100.1
```

The original server interface used:

```text
Interface: Ethernet0
IP: 192.168.100.147
Mask: 255.255.255.0
Gateway: 192.168.100.1
```

This interface remained connected to the physical network through VMware Bridged mode.

### Laboratory Network

A second interface was added to the server and connected to **VMware VMnet2**, configured as a Host-only network.

```text
Network: 192.168.200.0/24
Server IP: 192.168.200.2/24
Gateway: None
```

This network was used as the isolated laboratory segment.

```text
                     Physical Network
                    192.168.100.0/24
                           │
                           │ Ethernet0
                           │ 192.168.100.147
                  ┌────────▼─────────┐
                  │ Windows Server   │
                  │ WIN-IORAFMP55C9  │
                  │                  │
                  │ AD DS / DNS      │
                  │ DHCP             │
                  └────────┬─────────┘
                           │
                           │ Ethernet1
                           │ 192.168.200.2
                           │
                    ┌──────▼───────┐
                    │ VMware VMnet2│
                    │ Host-only     │
                    │ 192.168.200.0│
                    │      /24     │
                    └──────┬───────┘
                           │
                           │ DHCP
                           ▼
                  ┌────────────────┐
                  │ ClienteRobles  │
                  │ 192.168.200.100│
                  └────────────────┘
```

---

## VMware VMnet2 Configuration

The internal network used VMware **Host-only** networking.

```text
VMnet2
Subnet: 192.168.200.0/24
```

The host virtual adapter remained enabled.

During configuration, an address conflict was encountered with `.1`, as VMware was using that address within the virtual network.

For this reason, the Domain Controller was configured with:

```text
192.168.200.2
```

instead of `.1`.

This became the stable address used by the internal DNS and DHCP services.

---

## Domain Controller Network Configuration

### Ethernet0

```text
IP: 192.168.100.147
Subnet Mask: 255.255.255.0
Gateway: 192.168.100.1
DNS: 127.0.0.1
```

### Ethernet1

```text
IP: 192.168.200.2
Subnet Mask: 255.255.255.0
Gateway: None
DNS: 192.168.200.2
```

The second interface was used for the internal laboratory and DHCP service.

---

## DHCP Implementation

DHCP was installed and authorized in Active Directory.

The configured scope was:

```text
Scope Name: Laboratorio-VMnet2
Network: 192.168.200.0/24
Range: 192.168.200.100 - 192.168.200.200
```

The main options were:

```text
DNS Server: 192.168.200.2
DNS Domain: fred.castillo
```

The default lease duration remained at eight days.

No default gateway was configured for the scope because the laboratory network was intentionally isolated and did not require the Domain Controller to route traffic to the Internet.

---

## Windows Client Configuration

The laboratory client was:

```text
Name: ClienteRobles
```

The client was moved from the Bridged network to VMware VMnet2.

The network interface was configured for DHCP using:

```powershell
Set-NetIPInterface -Dhcp Enabled
ipconfig /release
ipconfig /renew
```

After the network change, the client initially retained its previous DNS configuration:

```text
192.168.100.147
```

This caused domain-resolution problems because the client was now operating in the `192.168.200.0/24` laboratory network.

The DNS configuration was reset with:

```powershell
Set-DnsClientServerAddress -InterfaceAlias "Ethernet0" -ResetServerAddresses
```

After this correction, the client received the appropriate network configuration from the internal DHCP service.

---

## Validation

The client successfully received an address from the configured DHCP scope.

The expected environment was:

```text
Client IP: 192.168.200.100
DNS Server: 192.168.200.2
DNS Domain: fred.castillo
```

Domain Controller discovery was verified with:

```cmd
nltest /dsgetdc:fred.castillo
```

DNS resolution was validated with:

```cmd
nslookup fred.castillo
```

These tests confirmed that the client could locate the Domain Controller and resolve the domain through the internal DNS service.

---

## Problems and Diagnosis

### Issue 1 — VMnet2 Address Conflict

The initial intention was to use:

```text
192.168.200.1
```

but that address was already being used within the VMware virtual network.

The final Domain Controller address was therefore:

```text
192.168.200.2
```

---

### Issue 2 — Previous DNS Configuration on the Client

After moving the client to VMnet2, it received a DHCP address from the new subnet but retained the previous DNS configuration.

The client was still using:

```text
192.168.100.147
```

as its DNS server.

Resetting the DNS client configuration allowed the system to use:

```text
192.168.200.2
```

correctly.

---

## Security Considerations

Using a dedicated Host-only network isolated the internal laboratory traffic from the physical network.

The design also prevented DHCP traffic and internal client communications from being directly exposed to the physical network.

The Domain Controller used a static address on the internal network to maintain a stable endpoint for services such as DNS, DHCP, and Active Directory.

---

## Evidence

The screenshots for this document will be stored under:

```text
../../assets/01-network/
```

Suggested files:

```text
01-network-adapter-configuration.png
02-vmnet2-configuration.png
03-dhcp-scope.png
04-client-dhcp-address.png
05-domain-validation.png
```

The images should come from the actual project evidence, primarily original screenshots or frames extracted from the project demonstration video.

---

## Result

The final implementation provided:

```text
✓ Stable Domain Controller addressing
✓ Isolated laboratory network
✓ DHCP service
✓ Internal DNS resolution
✓ Domain Controller discovery
✓ Windows client connectivity
✓ DHCP-based client addressing
```

This architecture became the foundation for the remaining project components.