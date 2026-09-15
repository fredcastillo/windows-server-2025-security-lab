# Windows Server Enterprise Infrastructure

Enterprise infrastructure implemented on **Windows Server** as the final project for the **Operating Systems Security** course.

The project integrates infrastructure services, Active Directory, DNS, DHCP, storage, file services, Group Policy, user management, folder redirection, security controls, vulnerability assessment, and access to a Linux environment hosted on AWS.

> **Implementation note:** the original academic assignment referenced Windows Server 2016 and Azure. The final implementation used **Windows Server 2025** and **AWS EC2**, while preserving the functional objectives of the project.

---

## Overview

The goal of the project was to build a functional domain-based enterprise environment for a simulated organization, using a Domain Controller, an isolated laboratory network, dedicated storage, department-based permissions, and security policies managed through Active Directory and Group Policy.

The environment also includes a Nessus vulnerability assessment and an Ubuntu Linux instance on AWS accessed through SSH key-based authentication.

### Main Components

- Windows Server 2025
- Active Directory Domain Services
- DNS
- DHCP
- Group Policy
- File Server
- NTFS permissions
- FSRM (File Server Resource Manager)
- Folder Redirection
- Password and account lockout policies
- VMware virtual networking
- Nessus vulnerability assessment
- AWS EC2
- Ubuntu Linux
- SSH key-based authentication
- PowerShell

---

## Architecture

The infrastructure uses an isolated laboratory network through **VMware VMnet2**.

```text
                         Physical Network
                        192.168.100.0/24
                               │
                               │
                    ┌─────────────────────┐
                    │ Windows Server 2025 │
                    │ WIN-IORAFMP55C9      │
                    │                     │
                    │ Ethernet0           │
                    │ 192.168.100.147     │
                    │                     │
                    │ Ethernet1           │
                    │ 192.168.200.2       │
                    │ DHCP / DNS / AD     │
                    └──────────┬──────────┘
                               │
                         VMware VMnet2
                      192.168.200.0/24
                               │
                               │ DHCP
                               ▼
                    ┌─────────────────────┐
                    │ Windows Client      │
                    │ ClienteRobles       │
                    │ 192.168.200.100     │
                    │ Domain: fred.castillo│
                    └─────────────────────┘
```

The `192.168.200.0/24` network was used as the internal laboratory segment for the client and domain services.

The Domain Controller used a static address of `192.168.200.2`, while the Windows client obtained its address through DHCP.

---

## Active Directory

The Active Directory environment used:

```text
Domain: fred.castillo
NetBIOS: FRED
Domain Controller: WIN-IORAFMP55C9
```

Five main organizational units were used:

```text
Dirección Administrativa
Dirección de Comunicaciones
Dirección de Gestión Humana
Dirección de tecnología
Dirección Legal
```

Each department also had a dedicated security group:

```text
GG_Administrativa
GG_Comunicaciones
GG_GestionHumana
GG_Tecnologia
GG_Legal
```

These groups were later used to control access to shared resources and department-specific policies.

---

## Storage

The server uses two virtual disks:

```text
Disk 0 → Operating system
Disk 1 → File Server
```

The second disk was configured as an NTFS volume:

```text
Drive: D:
Label: FileServer
Size: ~40 GB
File System: NTFS
```

The main file server structure is:

```text
D:\Departamentos\
├── Administrativa
├── Comunicaciones
├── GestionHumana
├── Legal
└── Tecnologia
```

Access was controlled using a combination of share-level and NTFS permissions.

---

## Group Policy

A dedicated GPO was implemented:

```text
Restricciones Escritorio - 4 Direcciones
```

The GPO was linked to:

- Dirección Administrativa
- Dirección Legal
- Dirección de Comunicaciones
- Dirección de Gestión Humana

The restrictions included:

```text
NoControlPanel = 1
NoRun          = 1
DisableCMD     = 2
```

A domain-based wallpaper was also configured:

```text
\\WIN-IORAFMP55C9\NETLOGON\wallpaper.jpg
```

The Technology department was intentionally kept outside this GPO to provide an unrestricted reference environment.

---

## Account Security

The final password and account lockout configuration included:

```text
Minimum password length: 7
Password complexity: Enabled
Account lockout threshold: 3 attempts
Lockout duration: 30 minutes
Observation window: 30 minutes
```

Domain-based time synchronization was also configured.

---

## Folder Redirection

Document redirection used:

```text
\\WIN-IORAFMP55C9\Usuarios$
```

with the physical storage location:

```text
D:\Usuarios
```

The implementation focused on redirecting the **Documents** folder.

This allows user documents to be stored on the server instead of relying exclusively on local client storage.

---

## File Server and FSRM

The file server implemented department-specific access controls.

**File Server Resource Manager (FSRM)** was used to restrict selected file categories.

### Technology

No restrictive File Screen was applied.

### Administrative, Legal and Human Resources

Mainly allowed:

- Office Files
- Text Files

Restricted categories included:

- Audio/Video
- Images
- Executables
- Compressed files
- Web pages
- Backup files
- Temporary files
- System files
- E-mail files

### Communications

Audio and video content was additionally allowed while other restricted categories remained blocked.

---

## Vulnerability Assessment

The environment was assessed using **Nessus** through a single scan performed on:

```text
19 August 2026
```

Scanned hosts:

```text
192.168.200.2
192.168.200.100
```

The report contained:

| Host | Critical | High | Medium | Low | Info |
|---|---:|---:|---:|---:|---:|
| 192.168.200.2 | 0 | 0 | 8 | 2 | 100 |
| 192.168.200.100 | 0 | 0 | 4 | 0 | 34 |
| **Total** | **0** | **0** | **12** | **2** | **134** |

The report contains **148 total findings**. This should not be interpreted as 148 independent vulnerabilities.

Relevant findings included:

- SSL certificates that could not be trusted
- SSL certificates with incorrect hostnames
- TLS 1.0 enabled
- TLS 1.1 enabled
- SWEET32 / 3DES on client RDP
- DHCP information disclosure
- ICMP Timestamp information disclosure

The complete analysis is documented in:

[`docs/07-vulnerability-assessment.md`](docs/07-vulnerability-assessment.md)

The original Nessus report is stored at:

[`findings/nessus-report.pdf`](findings/nessus-report.pdf)

> The Nessus scan should be treated as a baseline assessment. No second scan was performed after remediation.

---

## Featured Troubleshooting Case

One of the most interesting incidents occurred while attempting to access:

```text
\\WIN-IORAFMP55C9\Administrativa
```

through normal Windows Explorer navigation.

The user was a member of the expected department group and Kerberos authentication and SMB connectivity were working.

PowerShell tests successfully confirmed:

```powershell
Test-Path
Get-ChildItem
New-Item
Set-Content
```

Explorer could also be launched directly with:

```powershell
Start-Process explorer.exe "\\WIN-IORAFMP55C9\Administrativa"
```

The investigation isolated the issue to the normal Explorer access method while the identity, Kerberos authentication, SMB service, permissions, and network connectivity remained functional.

The complete investigation is documented here:

[`docs/06-troubleshooting-explorer-vs-powershell.md`](docs/06-troubleshooting-explorer-vs-powershell.md)

---

## AWS Cloud Access

The project also included a Linux instance hosted on **AWS EC2**.

The environment used:

```text
Ubuntu Linux
SSH
Key-based authentication
```

Access was performed using a private key rather than password authentication.

The implementation and connection procedure are documented in:

[`docs/08-cloud-ssh-access.md`](docs/08-cloud-ssh-access.md)

---

## Technical Documentation

| Document | Description |
|---|---|
| [01 - Network Architecture](docs/01-network-architecture.md) | VMware VMnet2, addressing and DHCP |
| [02 - Active Directory and Storage](docs/02-active-directory-and-storage.md) | AD, OUs, users, groups and disks |
| [03 - File Server and FSRM](docs/03-file-server-and-fsrm.md) | Shares, NTFS permissions and FSRM |
| [04 - Group Policy Restrictions](docs/04-group-policy-restrictions.md) | Restrictions, wallpaper and GPO |
| [05 - Folder Redirection and Time Sync](docs/05-folder-redirection-and-time-sync.md) | Documents redirection and time synchronization |
| [06 - Explorer vs PowerShell Troubleshooting](docs/06-troubleshooting-explorer-vs-powershell.md) | SMB/Explorer troubleshooting case |
| [07 - Vulnerability Assessment](docs/07-vulnerability-assessment.md) | Nessus assessment |
| [08 - Cloud SSH Access](docs/08-cloud-ssh-access.md) | AWS EC2 and SSH access |

---

## Video Demonstration

Complete project demonstration:

[YouTube — Windows Server Enterprise Infrastructure](https://www.youtube.com/watch?v=uRUL2Djjtlo&list=PLTicoclDhFkeclmj8sIWeO94_mm0e5Qdu)

### Timestamps

| Time | Section |
|---|---|
| 01:22 | AD / DNS / DHCP / Static IP |
| 03:03 | Storage and disks |
| 03:43 | Client and DHCP |
| 05:14 | OUs and users |
| 06:13 | GPO and restrictions |
| 08:32 | Folder Redirection |
| 10:55 | File Server and FSRM |
| 14:48 | Password / Lockout / NTP |
| 15:54 | Nessus |
| 16:58 | AWS Linux + SSH |

---

## Academic Requirements Mapping

| Requirement | Implementation |
|---|---|
| Active Directory | AD DS + Domain Controller |
| DNS | Active Directory-integrated DNS |
| DHCP | `192.168.200.100–200` scope |
| Client via DHCP | `ClienteRobles` |
| Department OUs | 5 OUs |
| Department users | Users distributed across OUs |
| GPO restrictions | Administrative, Legal, Communications and HR |
| Wallpaper | Domain-based wallpaper |
| Document redirection | `Usuarios$` / Folder Redirection |
| File Server | Department shares |
| File restrictions | FSRM |
| Account lockout | 3 failed attempts |
| Password policy | Complexity + minimum length |
| Time synchronization | Domain-based configuration |
| Vulnerability assessment | Nessus |
| Cloud Linux access | AWS EC2 + SSH |

---

## Key Technical Decisions

### Isolated laboratory network

A dedicated VMware host-only network was used for the internal lab:

```text
192.168.200.0/24
```

This separated the laboratory environment from the physical network.

### Static Domain Controller address

The Domain Controller used:

```text
192.168.200.2
```

to maintain a stable address for core domain services.

### Layered troubleshooting

Troubleshooting followed a layered validation process:

```text
Identity
→ Kerberos
→ Network connectivity
→ SMB
→ Share permissions
→ NTFS permissions
→ Application behavior
```

This helped avoid changing functioning components without evidence.

---

## Repository Structure

```text
docs/       → Technical documentation
scripts/    → PowerShell and configuration scripts
assets/     → Screenshots and diagrams
findings/   → Security assessment and risk documentation
```

---

#### 👨‍💻 Author

**Fred Castillo**  
*Information Security Technologist Student*  
*Aspiring Red Team | Offensive Security*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Fred%20Castillo-0077B5?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/fredcastillo11/)
[![GitHub](https://img.shields.io/badge/GitHub-fredcastillo-100000?style=for-the-badge&logo=github)](https://github.com/fredcastillo)
