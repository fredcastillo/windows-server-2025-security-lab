🇪🇸 **Español** | 🇬🇧 [English](README-EN.md)

# Active Directory Domain Services

![Windows Server 2025](https://img.shields.io/badge/Windows%20Server-2025-0078D6?style=flat&logo=windows&logoColor=white)
![Role](https://img.shields.io/badge/Role-Domain%20Controller-2D72D9?style=flat)
![Services](https://img.shields.io/badge/Services-AD%20DS%20%7C%20DNS-5E5E5E?style=flat)
![Virtualization](https://img.shields.io/badge/Virtualization-VMware-607078?style=flat&logo=vmware&logoColor=white)
![Forest](https://img.shields.io/badge/Forest-Single%20Forest-9C27B0?style=flat)
![OUs](https://img.shields.io/badge/OUs-5-FFB900?style=flat)
![Users](https://img.shields.io/badge/Users-25-4CAF50?style=flat)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=flat)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat)
![Demo Video](https://img.shields.io/badge/Demo%20Video-YouTube-FF0000?style=flat&logo=youtube&logoColor=white)

## Description

Implementation of a domain environment using **Windows Server 2025** as part of the Operating Systems Security laboratory.

This lab configures a **Domain Controller** from scratch with **Active Directory Domain Services (AD DS)** and **DNS**, followed by the creation of an organizational structure with five Organizational Units (OUs), each containing five user accounts.

## Objective

* Install Active Directory Domain Services.
* Install and configure DNS.
* Promote Windows Server 2025 to a Domain Controller.
* Create a new forest and domain.
* Create five Organizational Units.
* Create five users within each OU.
* Verify the operation of the services and domain structure.

## Environment

| Component            | Configuration                                |
| -------------------- | -------------------------------------------- |
| Operating System     | Windows Server 2025                          |
| Roles                | Active Directory Domain Services, DNS Server |
| Server Role          | Domain Controller                            |
| Virtualization       | VMware Workstation                           |
| Users                | 25                                           |
| Organizational Units | 5                                            |
| IP                   | `192.168.100.147`                            |
| Netmask              | `255.255.255.0`                              |
| Gateway              | `192.168.100.1`                              |
| Domain               | `fred.castillo`                              |

## Lab Structure

The final domain structure is organized as follows:

```text
Domain
│
├── IT Department
│   ├── User 01
│   ├── User 02
│   ├── User 03
│   ├── User 04
│   └── User 05
│
├── Administrative Department
│   ├── User 01
│   ├── User 02
│   ├── User 03
│   ├── User 04
│   └── User 05
│
├── Legal Department
│   ├── User 01
│   ├── User 02
│   ├── User 03
│   ├── User 04
│   └── User 05
│
├── Communications Department
│   ├── User 01
│   ├── User 02
│   ├── User 03
│   ├── User 04
│   └── User 05
│
└── Human Resources Department
    ├── User 01
    ├── User 02
    ├── User 03
    ├── User 04
    └── User 05
```

The lab concludes with **5 OUs and 25 user accounts** distributed across them.

## 1. Installing Active Directory Domain Services

The installation begins from **Server Manager**.

The following option is selected:

```text
Manage
└── Add Roles and Features
```

A role-based or feature-based installation is used, and the following role is selected:

```text
Active Directory Domain Services
```

The **DNS Server** role is also installed as part of the environment configuration.

After the installation is completed, Server Manager displays the notification required to continue with the server promotion.

## 2. Promoting the Server to a Domain Controller

After installing AD DS, the following option is selected:

```text
Promote this server to a domain controller
```

Since this is the first Domain Controller in the lab environment, the following option is selected:

```text
Add a new forest
```

The domain name is configured using the naming convention required by the original lab, based on the student's first name and last name.

A password is also configured for:

**Directory Services Restore Mode (DSRM)**

This password is required for directory service recovery operations.

## 3. Troubleshooting a Network Connectivity Issue

During the domain controller promotion, a network-related issue was encountered.

The cause was identified as the **network adapter of the virtual machine being disabled/disconnected**.

### Resolution

1. The promotion process was temporarily paused.
2. The virtual machine network configuration was checked.
3. The network adapter was enabled.
4. The procedure was resumed.
5. The server promotion was completed.
6. The server was restarted.

This highlighted the importance of verifying network connectivity before configuring services that depend on network communication, such as Active Directory and DNS.

## 4. Verifying the Domain Controller

After the restart, the server status is checked again through **Server Manager**.

The following items are verified:

* The domain name is displayed correctly.
* Active Directory Domain Services is installed.
* DNS is available.
* The server is operating as a Domain Controller.

The server is now ready for the creation of the organizational structure.

## 5. Creating Organizational Units

To organize the domain users, the following tool is used:

```text
Active Directory Users and Computers
```

A new:

```text
Organizational Unit
```

is created from the domain.

The following OUs are created:

```text
IT Department
Administrative Department
Legal Department
Communications Department
Human Resources Department
```

Organizational Units provide a way to organize accounts and later apply Group Policy according to the requirements of each department.

## 6. Creating User Accounts

User accounts are created inside each OU.

The process is performed through:

```text
Active Directory Users and Computers
└── Organizational Unit
    └── New
        └── User
```

During the creation of one of the accounts, a password-related issue occurred.

### Password Complexity Policy

Windows Server initially rejected the password because it did not meet the complexity requirements configured in the environment.

The password was changed to comply with the domain security policy.

This demonstrated how domain password policies affect the creation of new user accounts.

## 7. Final Result

After completing the lab, the environment contains:

* 1 Domain Controller.
* Active Directory Domain Services installed.
* DNS configured.
* 1 forest and domain.
* 5 Organizational Units.
* 25 user accounts.
* 5 users in each OU.

The environment is now ready to support the following laboratories in the project.

## Validation

The implementation is considered successful after verifying:

* Access to **Active Directory Users and Computers**.
* Existence of the domain.
* Existence of the five OUs.
* Five users inside each OU.
* Operation of AD DS and DNS services.
* Successful server startup after promotion.

## Evidence

Implementation evidence is stored in:

```text
screenshots/
```

The laboratory also includes a video demonstration showing the installation, configuration, and creation of the domain structure.

**Lab video:**
[Watch the demonstration on YouTube](https://www.youtube.com/watch?v=H8pR4lc_Jws)

## What I Learned

This laboratory provided hands-on experience with the fundamental components required to build a Windows-based Active Directory environment.

In addition to installing the required roles, the lab covered domain creation, OU organization, and user account management. It also included real troubleshooting scenarios during implementation, such as restoring virtual machine network connectivity and meeting password complexity requirements.

This environment serves as the foundation for the following laboratories in the project, including **Group Policy, WSUS, PKI, LAPS, and privilege management**.

---

#### Author

**Fred Castillo**
*Information Security Technology Student*
*Aspiring Red Team | Offensive Security*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Fred%20Castillo-0077B5?style=for-the-badge\&logo=linkedin)](https://www.linkedin.com/in/fredcastillo11/)
[![GitHub](https://img.shields.io/badge/GitHub-fredcastillo-100000?style=for-the-badge\&logo=github)](https://github.com/fredcastillo)

---
