🇬🇧 **English** | 🇪🇸 [Español](README.md)

# Windows Server Security Lab

Hands-on laboratory focused on Windows infrastructure administration and security, developed as part of my Information Security studies.

The environment is based on **Windows Server 2025** and Windows client machines joined to a domain. Throughout the laboratory, different components of an enterprise environment are implemented and secured, ranging from Active Directory deployment to security policies, update management, public key infrastructure, vulnerability assessment, and privileged account management.

This repository documents the practical exercises I have completed, including configurations, procedures, evidence, and results.

> **Main platform:** Windows Server 2025
> **Virtualization:** VMware Workstation / VirtualBox

## Labs

| #  | Lab                                                                    | Main topics                                               |
| -- | ---------------------------------------------------------------------- | --------------------------------------------------------- |
| 01 | [Active Directory](./01-active-directory/)                             | AD DS, DNS, OUs, users, domain                            |
| 02 | [Group Policy](./02-group-policy/)                                     | GPOs, restrictions, auditing, time synchronization        |
| 03 | [WSUS](./03-wsus/)                                                     | Update management, GPO configuration, client systems      |
| 04 | [PKI & Secure Remote Access](./04-pki-and-secure-remote-access/)       | CA, certificates, SSH public-key authentication           |
| 05 | [Vulnerability Assessment](./05-vulnerability-assessment/)             | Nessus, vulnerability scanning, risk analysis             |
| 06 | [Vulnerability Remediation](./06-vulnerability-remediation/)           | Remediation, validation, results comparison               |
| 07 | [Microsoft LAPS](./07-laps/)                                           | Local administrator passwords, expiration, access control |
| 08 | [Local Administrator Management](./08-local-administrator-management/) | Local accounts, domain groups, administrative privileges  |

## Environment

The main laboratory environment consists of a Windows Server 2025 domain controller and Windows client machines.

```text
                         Windows Server 2025
                       ┌─────────────────────┐
                       │ Active Directory    │
                       │ DNS                 │
                       │ Group Policy        │
                       │ WSUS                │
                       │ PKI / CA            │
                       └──────────┬──────────┘
                                  │
                           Domain Environment
                                  │
                    ┌─────────────┴─────────────┐
                    │                           │
             Windows Client 01           Windows Client 02
                    │                           │
                    └─────────────┬─────────────┘
                                  │
                         Security Assessments
                                  │
                                Nessus
```

The number of virtual machines and their configuration may vary depending on the laboratory.

## Main Topics

The laboratory covers the following areas:

* Active Directory Domain Services
* DNS
* Organizational Units and group management
* Group Policy
* Windows auditing
* WSUS and update management
* Public Key Infrastructure (PKI)
* Certificate Services
* SSH public-key authentication
* Vulnerability assessment
* Vulnerability remediation
* Microsoft LAPS
* Local administrator account management
* Access control
* Least privilege

## Repository Structure

```text
windows-server-security-lab/
│
├── README.md
├── README-EN.md
│
├── 01-active-directory/
│   └── README.md
│
├── 02-group-policy/
│   └── README.md
│
├── 03-wsus/
│   └── README.md
│
├── 04-pki-and-secure-remote-access/
│   └── README.md
│
├── 05-vulnerability-assessment/
│   └── README.md
│
├── 06-vulnerability-remediation/
│   └── README.md
│
├── 07-laps/
│   └── README.md
│
└── 08-local-administrator-management/
    └── README.md
```

Each directory contains the documentation and evidence associated with its corresponding laboratory.

## Documentation

Depending on the laboratory, each directory may contain:

* Configuration procedures
* PowerShell commands
* Screenshots
* Infrastructure or network diagrams
* Validation steps
* Results
* Lessons learned
* Video demonstrations

The goal is to document not only how a configuration was implemented, but also how its functionality was tested and validated.

## Notes

The original academic instructions for some exercises referenced **Windows Server 2016**. However, all implementations documented in this repository were performed using **Windows Server 2025**.

Some laboratories, particularly those involving PKI and vulnerability assessment, also use Linux systems or additional security tools as part of the environment.

## Status

In progress.

The repository will continue to include new laboratories, configurations, and documentation as the environment evolves.

---

#### 👨‍💻 Autor

**Fred Castillo**  
*Estudiante de Tecnólogo en Seguridad Informática*  
*Aspirante a Red Team | Seguridad Ofensiva*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Fred%20Castillo-0077B5?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/fredcastillo11/)
[![GitHub](https://img.shields.io/badge/GitHub-fredcastillo-100000?style=for-the-badge&logo=github)](https://github.com/fredcastillo)

---
