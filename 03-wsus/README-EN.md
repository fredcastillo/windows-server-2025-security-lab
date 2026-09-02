🇬🇧 **English** | 🇪🇸 [Español](README.md)

<h1 align="center">Windows Server Update Services (WSUS) Deployment</h1>

<p align="center">
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Windows%20Server-2025-0078D6?style=for-the-badge&logo=windows&logoColor=white" alt="Windows Server"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Role-Domain%20Controller%20%26%20WSUS-2D72D9?style=for-the-badge" alt="DC + WSUS"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Service-Windows%20Server%20Update%20Services-5E5E5E?style=for-the-badge" alt="WSUS"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Products-Windows%2010%20%7C%20Windows%20Server-4CAF50?style=for-the-badge" alt="Products"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Classifications-Critical%20%26%20Security%20Updates-FF6F00?style=for-the-badge" alt="Classifications"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/GPO%20Servers-Download%20%26%20Notify-9C27B0?style=for-the-badge" alt="Server GPO"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Update%20Approval-Servicing%20Stack%20Update-FFA500?style=for-the-badge" alt="Update Approval"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge" alt="Status"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License"></a>
  <a href="https://www.youtube.com/watch?v=QQKFb57v7rY"><img src="https://img.shields.io/badge/Demo%20Video-YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white" alt="Demo Video"></a>
</p>

## Description

Hands-on laboratory covering the implementation of **Windows Server Update Services (WSUS)** to centrally manage and distribute updates in a Windows domain environment.

The laboratory demonstrates how to install and configure WSUS on Windows Server, select the products and update classifications to synchronize, configure domain computers through **Group Policy**, and control Windows Update behavior on clients and servers.

The laboratory also includes a test where an update is approved through WSUS and detected by a client computer.

## Objectives

* Install the WSUS role.
* Configure synchronization with Microsoft Update.
* Select Windows products to manage.
* Select update classifications.
* Create and configure a client WSUS GPO.
* Configure automatic update installation on clients.
* Schedule client update installation.
* Configure servers to download updates and notify the administrator.
* Verify applied policies using `gpresult`.
* Approve an update from WSUS.
* Verify that the client detects the update from the WSUS server.

## Environment

| Component      | Configuration                  |
| -------------- | ------------------------------ |
| Windows Server | Windows Server 2025            |
| Service        | Windows Server Update Services |
| Management     | Group Policy                   |
| Client         | Windows 10/11                  |
| Virtualization | VMware Workstation             |
| Domain         | `fred.castillo`                |

## Architecture

![Laboratory architecture](diagrams/diagram.png)

```text
                         Windows Server 2025
                               │
                               │ WSUS
                               ▼
                    Windows Server Update
                         Services
                               │
                ┌──────────────┴──────────────┐
                │                             │
                ▼                             ▼
          Client Computers              Server Computers
                │                             │
                │ GPO                         │ GPO
                ▼                             ▼
        Auto Download/Install          Download + Notify
        Scheduled: 2:00 AM                Administrator
                │
                ▼
         Windows Update
```

# Part 1 — WSUS Installation

## 1. Install the WSUS Role

On Windows Server, open:

```text
Server Manager
```

Select:

```text
Manage
└── Add Roles and Features
```

Use a role-based or feature-based installation.

Select:

```text
Windows Server Update Services
```

Complete the installation wizard and allow Windows Server to install the required components.

After installation, complete the WSUS post-deployment configuration and restart the server if required.

![WSUS role installed](screenshots/01-wsus-role-installed.png)

---

# Part 2 — Initial WSUS Configuration

## 2. Open the WSUS Console

After the role is installed, open:

```text
Server Manager
└── Tools
    └── Windows Server Update Services
```

The initial WSUS configuration is performed from this console.

Synchronization is configured to use:

```text
Microsoft Update
```

as the update source.

![WSUS console](screenshots/02-wsus-console.png)

---

## 3. Select Products

During WSUS configuration, select the Microsoft products that will be managed.

This laboratory includes:

```text
Windows 10 version 1903 and later
Windows Server version 1903 and later
```

Selecting only the required products helps limit the updates synchronized by the WSUS server.

![Selected WSUS products](screenshots/03-wsus-products.png)

---

## 4. Select Update Classifications

WSUS allows administrators to select which types of updates should be synchronized.

This laboratory uses:

```text
Critical Updates
Security Updates
```

This focuses synchronization on critical fixes and security-related updates.

![WSUS update classifications](screenshots/04-wsus-classifications.png)

---

# Part 3 — Configure Computers through Group Policy

## 5. Configure the Client WSUS GPO

To make domain computers use the internal WSUS server instead of communicating directly with Microsoft Update, configure a Group Policy Object.

The relevant settings are located under:

```text
Computer Configuration
└── Policies
    └── Administrative Templates
        └── Windows Components
            └── Windows Update
```

Configure Windows Update to use the internal WSUS server.

A detection interval of:

```text
1 hour
```

is also configured so that clients periodically check for approved updates.

![Client WSUS GPO](screenshots/05-client-wsus-gpo.png)

---

## 6. Schedule Client Updates

Client computers are configured to automatically download and install updates.

The configuration uses:

```text
Automatic Download and Scheduled Install
```

with a scheduled installation time of:

```text
2:00 AM
```

This allows approved updates to be downloaded and installed automatically according to the configured policy.

![Client scheduled updates](screenshots/06-client-scheduled-updates.png)

---

# Part 4 — Configure Servers

## 7. Configure the Server Update Policy

Servers use a different update policy from client computers.

The server configuration is:

```text
Automatic download
        +
Notify the administrator
```

before installation.

The configuration is performed through Group Policy under the Windows Update policies.

![Server update policy](screenshots/07-server-update-policy.png)

This allows different update behavior to be applied according to the system role.

---

# Part 5 — Apply and Verify the Policies

## 8. Refresh Group Policy

On the client, force a Group Policy update:

```powershell
gpupdate /force
```

Then verify the applied policies with:

```powershell
gpresult /r
```

![Applied Group Policy results](screenshots/08-gpresult.png)

This verifies that the WSUS-related Group Policy was received by the client.

---

# Part 6 — Approve and Test an Update

## 9. Approve an Update in WSUS

From the WSUS console, locate an available update.

The laboratory uses:

```text
Servicing Stack Update for Windows 10
```

The update is approved for:

```text
Unassigned Computers
```

After approval, WSUS can offer the update to applicable computers.

![Approved update in WSUS](screenshots/09-update-approved.png)

---

## 10. Verify Update Detection on the Client

On the client computer, open Windows Update.

After the client performs its detection cycle, Windows should indicate that update settings are managed by the organization.

This confirms the following workflow:

```text
WSUS
 │
 │ Approved update
 ▼
Windows Client
 │
 │ Detection
 ▼
Windows Update
 │
 ▼
Available update
```

---

# Applied Configuration

| Configuration          | Value                                   |
| ---------------------- | --------------------------------------- |
| Update source          | Microsoft Update                        |
| Products               | Windows 10 1903+ / Windows Server 1903+ |
| Classifications        | Critical Updates / Security Updates     |
| Client detection       | Every 1 hour                            |
| Client installation    | Automatic                               |
| Scheduled installation | 2:00 AM                                 |
| Server behavior        | Download and notify administrator       |
| Test                   | Update approved through WSUS            |

---

# Validation

The implementation verified:

```text
✓ WSUS installed
✓ WSUS console configured
✓ Products selected
✓ Update classifications selected
✓ Client WSUS GPO configured
✓ Client installation scheduled for 2:00 AM
✓ Server update policy configured
✓ Policies applied to the client
✓ Update approved through WSUS
✓ Client configured to use WSUS
```

---

# Result

WSUS was configured as the centralized update management point for the laboratory environment.

Client computers receive a Group Policy configuration instructing them to use the WSUS server, periodically detect updates, and automatically install approved updates at **2:00 AM**.

Servers use a separate policy that allows updates to be downloaded while notifying the administrator before installation.

Approving an update through the WSUS console allowed the complete workflow between the WSUS server and the client computer to be validated.

## Video

[Watch the laboratory demonstration on YouTube](https://www.youtube.com/watch?v=QQKFb57v7rY)

---

## 👨‍💻 Author

**Fred Castillo**  
*Information Security Technology Student*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Fred%20Castillo-0077B5?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/fredcastillo11/)
[![GitHub](https://img.shields.io/badge/GitHub-fredcastillo-100000?style=for-the-badge&logo=github)](https://github.com/fredcastillo)

---
