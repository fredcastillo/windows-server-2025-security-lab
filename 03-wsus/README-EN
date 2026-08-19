🇬🇧 **English** | 🇪🇸 [Español](README.md)

# WSUS Installation and Configuration

Implementation of **Windows Server Update Services (WSUS)** on Windows Server 2025 to centrally manage and distribute updates within a Windows domain environment.

This laboratory is part of the Operating Systems Security project and builds on the `fred.castillo` domain configured in the previous modules.

The objective is to deploy a WSUS server, configure domain computers to use it through **Group Policy**, and apply different update behaviors to client computers and servers.

## Objective

* Install the **Windows Server Update Services (WSUS)** role.
* Configure WSUS as the update management server for the environment.
* Select the products and update classifications to synchronize.
* Configure GPOs to direct domain computers to the WSUS server.
* Configure client PCs to automatically download and install updates at 2:00 AM.
* Configure servers to download updates and notify the administrator before installation.
* Approve an update through WSUS.
* Verify that the client receives the approved update.

## Environment

| Component                | Configuration                                         |
| ------------------------ | ----------------------------------------------------- |
| Operating System         | Windows Server 2025                                   |
| Domain Controller / WSUS | `192.168.100.147`                                     |
| Domain                   | `fred.castillo`                                       |
| Service                  | Windows Server Update Services                        |
| Clients                  | Windows 10/11                                         |
| Virtualization           | VMware Workstation                                    |
| Management               | Server Manager, WSUS Console, Group Policy Management |

## Architecture

The Windows Server 2025 system acts as both the Domain Controller and WSUS server in the laboratory.

```text
                         Windows Server 2025
                         DC01 / WSUS Server
                           192.168.100.147
                                  │
                    ┌─────────────┴─────────────┐
                    │                           │
              Client GPO                  Server GPO
                    │                           │
                    ▼                           ▼
             Windows Client                Windows Server
                    │                           │
                    └─────────────┬─────────────┘
                                  │
                           Windows Update
                                  │
                                  ▼
                               WSUS
                                  │
                           Microsoft Update
```

The policies apply different update behaviors depending on the type of system being managed.

---

# 1. Installing the WSUS Role

The installation starts from **Server Manager**.

Select:

```text
Manage
└── Add Roles and Features
```

From the available server roles, select:

```text
Windows Server Update Services
```

Complete the required WSUS components and continue with the installation.

After the initial installation is completed, Server Manager displays the required post-deployment configuration tasks.

---

# 2. Post-Installation Configuration

After installing the role, complete the required **Post-Deployment Configuration** tasks.

The server must be restarted to complete the installation successfully.

After the restart, open:

```text
Server Manager
└── Tools
    └── Windows Server Update Services
```

---

# 3. Initial WSUS Configuration

When the WSUS console is opened for the first time, the configuration wizard is launched.

The server is configured as the **primary update server** for the laboratory and synchronizes directly from **Microsoft Update**.

## Synchronization Source

```text
Microsoft Update
        │
        ▼
      WSUS
        │
        ▼
Domain Computers
```

This allows updates to be centrally managed before being distributed to systems in the environment.

---

# 4. Products and Classifications

To reduce unnecessary synchronization, only the products and update types required for the laboratory are selected.

## Products

Unnecessary default products are disabled and the following products are selected:

* **Windows 10, version 1903 and later**
* **Windows Server, version 1903 and later**

The operating system version is checked using:

```cmd
winver
```

## Classifications

The following classifications are selected:

* **Critical Updates**
* **Security Updates**

This limits synchronization to update categories relevant to critical fixes and security.

---

# 5. Computer Organization

To apply different update behaviors, client computers and servers are managed separately.

Conceptually:

```text
fred.castillo
│
├── Computers / Clients
│      └── Windows Client
│
└── Servers
       └── Windows Server
```

This separation allows different WSUS policies to be applied depending on the system being managed.

---

# 6. Client GPO

A dedicated GPO is configured for client PCs.

The policy directs the client systems to the local WSUS server.

## Main configuration

The policy specifies:

* Local WSUS server address.
* Detection frequency: **every hour**.
* Automatic download of updates.
* Scheduled installation at **2:00 AM**.

Expected behavior:

```text
Client
   │
   ├── Checks WSUS every hour
   │
   ├── Downloads automatically
   │
   └── Installs at 2:00 AM
```

The update service configuration points to the WSUS server used in the laboratory.

---

# 7. Server GPO

Servers use a different policy to avoid automatic installations that could cause unexpected restarts.

The configured behavior is:

**Automatically download updates and notify the administrator for installation.**

Expected behavior:

```text
Server
   │
   ├── Detects update
   │
   ├── Downloads update
   │
   └── Notifies administrator
             │
             └── Manual installation
```

This provides a more controlled update process for server systems.

---

# 8. Applying the GPOs

After creating and configuring the GPOs, policy processing is forced with:

```cmd
gpupdate /force
```

The command is used to accelerate the application of the new configurations on the laboratory systems.

The applied policies can also be checked with:

```cmd
gpresult /r
```

---

# 9. Approving an Update from WSUS

To verify the complete update workflow, an available update is approved from the WSUS console.

Navigate to:

```text
WSUS
└── All Updates
```

An available update is selected:

**Servicing Stack Update for Windows 10**

Then:

```text
Right Click
└── Approve
```

The update is approved for the computer group used during testing:

```text
Unassigned Computers
```

The workflow becomes:

```text
Microsoft Update
       │
       ▼
      WSUS
       │
       │ Update available
       ▼
  Administrator
       │
       │ Approve
       ▼
Computer Group
       │
       ▼
Windows Client
```

---

# 10. Client Validation

After the policies are applied and the update is approved, validation is performed from the Windows client.

Open:

```text
Settings
└── Windows Update
```

The client displays a message indicating that:

> Some settings are managed by your organization.

This provides an indication that Windows Update settings are being managed through policy.

The client then selects:

**Check for updates**

The client detects the update previously approved through WSUS and begins downloading it.

The update used in the demonstration is:

**Servicing Stack Update for Windows 10**

This verifies the complete workflow:

```text
WSUS
  ↓
Approval
  ↓
GPO
  ↓
Client
  ↓
Detection
  ↓
Download
```

---

# 11. Result

At the end of the laboratory, the environment has a centralized update management system.

```text
                        Microsoft Update
                               │
                               ▼
                         Windows Server
                              WSUS
                               │
                    ┌──────────┴──────────┐
                    │                     │
               Client GPO           Server GPO
                    │                     │
                    ▼                     ▼
              Windows Client        Windows Server
                    │                     │
              Install 2:00 AM      Download +
                                    Notify
```

The update approval test confirms that the client can receive content managed through WSUS.

---

# Validation

| Component       | Validation                             |
| --------------- | -------------------------------------- |
| WSUS            | Console installed and configured       |
| Products        | Windows 10 and Windows Server selected |
| Classifications | Critical Updates and Security Updates  |
| Client GPO      | WSUS server + scheduled installation   |
| Server GPO      | Download and notification              |
| GPO application | `gpupdate /force` / `gpresult /r`      |
| Update          | Approved through WSUS                  |
| Client          | Update detected and downloaded         |

---

# Evidence

Screenshots for this laboratory are stored in:

```text
screenshots/
```

Evidence includes:

* WSUS role installation.
* Initial WSUS configuration.
* Products and classifications.
* GPO configuration.
* Update approval.
* Client-side validation.

## Video

**Lab demonstration:**
[Watch the video on YouTube](https://www.youtube.com/watch?v=QQKFb57v7rY)

---

## What I Learned

This laboratory provided hands-on experience with **WSUS as a centralized update management solution** within a Windows domain environment.

The lab covered service installation and configuration, product and classification selection, Group Policy integration, and different update behaviors for client computers and servers.

It also demonstrated the complete update workflow:

```text
Synchronization
      ↓
Selection
      ↓
Approval
      ↓
GPO Application
      ↓
Client Detection
      ↓
Download
      ↓
Installation
```

---

## 👨‍💻 Autor

*Information Security Technology Student*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Fred%20Castillo-0077B5?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/fredcastillo11/)
[![GitHub](https://img.shields.io/badge/GitHub-fredcastillo-100000?style=for-the-badge&logo=github)](https://github.com/fredcastillo)

---
