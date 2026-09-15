# Technical Documentation

This directory contains the technical documentation for the **Windows Server Enterprise Infrastructure** project.

Each document focuses on a specific part of the implementation and follows the same general structure:

```text
Context
→ Implementation
→ Problem / Incident
→ Diagnosis
→ Solution
→ Validation
```

The documentation is based on the actual project implementation, including configuration decisions, troubleshooting evidence, validation commands, and security findings.

---

## Documentation Index

### 01 — Network Architecture

[01-network-architecture.md](01-network-architecture.md)

Covers:

- VMware network architecture
- Physical and laboratory networks
- Dual-NIC configuration
- Static addressing
- VMnet2 Host-only network
- DHCP scope
- DNS configuration
- Windows client DHCP configuration
- Connectivity and domain validation

---

### 02 — Active Directory and Storage

[02-active-directory-and-storage.md](02-active-directory-and-storage.md)

Covers:

- Active Directory domain
- Organizational Units
- Users
- Security groups
- Password policy
- Account lockout
- Domain Controller storage
- Second virtual disk
- NTFS formatting
- File Server volume

---

### 03 — File Server and FSRM

[03-file-server-and-fsrm.md](03-file-server-and-fsrm.md)

Covers:

- Department folders
- SMB shares
- Share permissions
- NTFS permissions
- Department security groups
- FSRM
- File Screens
- File type restrictions
- Validation

---

### 04 — Group Policy Restrictions

[04-group-policy-restrictions.md](04-group-policy-restrictions.md)

Covers:

- `Restricciones Escritorio - 4 Direcciones`
- GPO scope
- Control Panel restriction
- Run restriction
- Command Prompt restriction
- Wallpaper configuration
- Registry-based policy settings
- `gpresult` validation

---

### 05 — Folder Redirection and Time Synchronization

[05-folder-redirection-and-time-sync.md](05-folder-redirection-and-time-sync.md)

Covers:

- `Usuarios$` share
- `D:\Usuarios`
- Documents Folder Redirection
- User permissions
- Automatic folder creation
- Domain time synchronization
- `w32tm`
- Kerberos-related time validation

---

### 06 — Explorer vs PowerShell Troubleshooting

[06-troubleshooting-explorer-vs-powershell.md](06-troubleshooting-explorer-vs-powershell.md)

Detailed troubleshooting case study covering:

- SMB access problem
- User identity validation
- Group membership
- Kerberos ticket validation
- Share permissions
- NTFS permissions
- SMB session validation
- Port 445 connectivity
- PowerShell access
- Explorer behavior
- Final isolation of the issue

This is the main troubleshooting case study of the project.

---

### 07 — Vulnerability Assessment

[07-vulnerability-assessment.md](07-vulnerability-assessment.md)

Covers:

- Nessus scan methodology
- Scan scope
- Hosts assessed
- Findings by severity
- SSL/TLS findings
- RDP findings
- SWEET32
- DHCP information disclosure
- ICMP Timestamp
- Root-cause grouping
- Recommendations
- Assessment limitations

The assessment is based on a single Nessus report.

---

### 08 — Cloud SSH Access

[08-cloud-ssh-access.md](08-cloud-ssh-access.md)

Covers:

- AWS EC2
- Ubuntu Linux
- Instance access
- Security group configuration
- SSH
- Private key authentication
- Windows-to-Linux connectivity
- SSH validation

---

## Evidence

Screenshots, diagrams, and visual evidence are stored in:

```text
../assets/
```

organized by documentation section.

Examples:

```text
assets/01-network/
assets/02-active-directory/
assets/03-file-server/
assets/04-gpo/
assets/05-folder-redirection/
assets/06-troubleshooting/
assets/07-nessus/
assets/08-aws/
```

---

## Scripts

Reusable scripts and configuration commands are stored in:

```text
../scripts/
```

organized according to their purpose:

```text
scripts/
├── networking/
├── active-directory/
├── file-server/
├── group-policy/
└── validation/
```

Sensitive information such as passwords, private keys, tokens, and other secrets must never be committed to the repository.

---

## Assessment Methodology

The documentation distinguishes between:

- configuration
- observed behavior
- validation results
- security findings
- interpretation

This is especially important for the vulnerability assessment. Nessus findings are not automatically treated as individual vulnerabilities, and the project includes only one baseline scan.

---

## Project Environment

```text
Windows Server 2025
Active Directory
DNS
DHCP
VMware
Windows Client
Nessus
AWS EC2
Ubuntu
SSH
PowerShell
```

---

## Main Project

Return to the main project page:

[← Back to README](../README.md)

English version:

[README-EN.md](../README-EN.md)