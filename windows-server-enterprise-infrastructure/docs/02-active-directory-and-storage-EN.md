# 02 — Active Directory and Storage

## Context

The project required a Windows Server environment with **Active Directory**, organizational units, users, security groups, password controls, account lockout policies, and dedicated storage for file services.

The final implementation used:

```text
Operating System: Windows Server 2025
Domain: fred.castillo
NetBIOS: FRED
Domain Controller: WIN-IORAFMP55C9
```

---

## Active Directory Environment

Active Directory Domain Services and DNS were already present on the server and formed the foundation of the final infrastructure.

Five main Organizational Units were used to represent the departments:

```text
Dirección Administrativa
Dirección de Comunicaciones
Dirección de Gestión Humana
Dirección de tecnología
Dirección Legal
```

Additional containers and OUs were also present in the environment, including:

```text
Domain Controllers
Domain PC's
empresa
```

The five departmental OUs listed above were the ones used to represent the organizational structure required by the final project.

---

## Users

The environment contained five users per department:

```text
5 departments × 5 users = 25 users
```

For the final demonstrations, two representative users from each department were used.

This allowed the project to validate:

- Group membership
- GPO application
- File access
- Folder Redirection
- Authentication
- Department-specific restrictions

---

## Security Groups

Five security groups were created:

```text
GG_Tecnologia
GG_Administrativa
GG_Legal
GG_Comunicaciones
GG_GestionHumana
```

Each group was associated with its corresponding department.

These groups were later used for:

- File Server permissions
- SMB share access
- Department isolation
- Policy targeting

Using security groups allowed permissions to be managed by department rather than assigned individually to every user.

---

## Password and Account Lockout Policy

The final configuration included:

```text
Minimum password length: 7
Password complexity: Enabled
Lockout threshold: 3 failed attempts
Lockout duration: 30 minutes
Observation window: 30 minutes
```

The account lockout threshold was initially:

```text
0
```

which disabled account lockout.

It was changed to:

```text
3
```

to meet the project's security requirement.

The final policy was configured using:

```powershell
Set-ADDefaultDomainPasswordPolicy `
    -Identity fred.castillo `
    -LockoutThreshold 3 `
    -LockoutDuration "00:30:00" `
    -LockoutObservationWindow "00:30:00"
```

---

## Storage Architecture

The server was configured with two virtual disks:

```text
Disk 0 → Operating system
Disk 1 → File Server
```

The second disk provided dedicated storage for departmental shares and user data.

### Disk 1

```text
Capacity: approximately 40 GB
Partition style: GPT
Drive letter: D:
File system: NTFS
Volume label: FileServer
```

The disk was prepared using PowerShell:

```powershell
Initialize-Disk -Number 1 -PartitionStyle GPT

New-Partition `
    -DiskNumber 1 `
    -UseMaximumSize `
    -DriveLetter D

Format-Volume `
    -DriveLetter D `
    -FileSystem NTFS `
    -NewFileSystemLabel "FileServer" `
    -Confirm:$false
```

---

## Drive Letter Issue

During storage configuration, the second disk could not initially use `D:` because the CD/DVD device was already using that drive letter.

The optical device was reassigned so that the new File Server volume could use:

```text
D:
```

The disk was then formatted as NTFS and labeled:

```text
FileServer
```

---

## File Server Structure

The dedicated volume became the storage foundation for the department shares:

```text
D:\Departamentos\
```

The final structure was:

```text
D:\Departamentos\
├── Administrativa
├── Comunicaciones
├── GestionHumana
├── Legal
└── Tecnologia
```

A separate location was also created for user document storage:

```text
D:\Usuarios
```

This directory was later used for Folder Redirection.

---

## Relationship Between Active Directory and Storage

The infrastructure connected Active Directory identities to storage permissions.

The model was:

```text
User
   ↓
Department
   ↓
Security Group
   ↓
SMB Share
   ↓
NTFS Permissions
```

Example:

```text
AlanS12
   ↓
GG_Administrativa
   ↓
Administrativa share
   ↓
D:\Departamentos\Administrativa
```

This model was used as the foundation for departmental resource access.

---

## Existing Infrastructure

Some components already existed before the final project integration.

These included:

- Active Directory Domain Services
- DNS
- Five departmental OUs
- Existing users
- WSUS
- Microsoft LAPS
- NTP-related Group Policy
- Other laboratory policies

The final implementation did not unnecessarily recreate working infrastructure.

Instead, the existing environment was extended with the components required by the final project.

---

## Configuration Changes

The main additions and modifications relevant to the project were:

```text
✓ DHCP
✓ Secondary network interface
✓ VMware VMnet2 integration
✓ Dedicated D: storage
✓ Department security groups
✓ File Server
✓ FSRM
✓ Department access permissions
✓ Desktop restriction GPO
✓ Folder Redirection GPO
✓ Account lockout configuration
```

---

## Validation

Active Directory configuration was validated through the administrative tools and PowerShell.

Examples included:

```powershell
Get-ADUser
Get-ADGroup
Get-ADOrganizationalUnit
Get-ADDefaultDomainPasswordPolicy
```

The environment was also validated from the Windows client after joining the domain.

Domain Controller discovery was verified using:

```cmd
nltest /dsgetdc:fred.castillo
```

---

## Security Considerations

The Active Directory structure used security groups to manage permissions instead of relying on individual user assignments whenever practical.

This improves maintainability and makes access easier to audit.

The password and lockout configuration also introduced a basic protection layer against repeated authentication attempts.

The repository must never contain:

- Passwords
- Private keys
- Tokens
- Credentials
- Other secrets

---

## Evidence

The screenshots for this document will be stored under:

```text
../../assets/02-active-directory/
```

Suggested files:

```text
01-domain-configuration.png
02-organizational-units.png
03-users.png
04-security-groups.png
05-password-policy.png
06-storage-disks.png
07-file-server-volume.png
```

---

## Result

The final configuration provided:

```text
✓ Domain-based identity management
✓ Five departmental OUs
✓ Department security groups
✓ 25 existing users
✓ Representative users for testing
✓ Password complexity
✓ Account lockout after three failed attempts
✓ Dedicated File Server storage
✓ NTFS-formatted D: volume
```

These components provided the identity and storage foundation required by the remaining project services.