<h1 align="center">Group Policy Objects (GPO) Implementation</h1>

<p align="center">
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Windows%20Server-2025-0078D6?style=for-the-badge&logo=windows&logoColor=white" alt="Windows Server"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Role-Domain%20Controller-2D72D9?style=for-the-badge" alt="Domain Controller"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Technology-GPO-5E5E5E?style=for-the-badge" alt="GPO"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Software%20Deployment-Chrome-4285F4?style=for-the-badge&logo=googlechrome&logoColor=white" alt="Chrome Deployment"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Restrictions-Control%20Panel%20%7C%20CMD%20%7C%20Regedit-FF6F00?style=for-the-badge" alt="Restrictions"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Audit-Logon%20%7C%20Process%20Tracking%20%7C%20System%20Events-9C27B0?style=for-the-badge" alt="Audit Policies"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/NTP-Time%20Synchronization-4CAF50?style=for-the-badge" alt="NTP"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge" alt="Status"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License"></a>
  <a href="https://www.youtube.com/watch?v=hRDxHtdWJE8"><img src="https://img.shields.io/badge/Demo%20Video-YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white" alt="Demo Video"></a>
</p>

## Description

Implementation and validation of **Group Policy Objects (GPOs)** in a domain environment based on **Windows Server 2025**, as part of the Operating Systems Security laboratory.

This lab uses Group Policy to automate software deployment, restrict access to administrative tools, configure time synchronization, and enable security auditing policies across domain-joined systems.

## Objective

Implement and validate the following policies:

* Automated installation of **Google Chrome** through GPO.
* Restrict access to **Control Panel**.
* Restrict access to **Command Prompt (CMD)**.
* Restrict access to **Registry Editor (Regedit)**.
* Configure time synchronization using the **Domain Controller**.
* Audit logon events.
* Audit security-related events.
* Audit process creation and process tracking.

## Environment

| Component               | Configuration                   |
| ----------------------- | ------------------------------- |
| Server operating system | Windows Server 2025             |
| Domain Controller       | `192.168.100.147`               |
| Domain                  | `fred.castillo`                 |
| Client                  | Windows 10/11                   |
| Management tool         | Group Policy Management         |
| Virtualization          | VMware Workstation              |
| Deployed software       | Google Chrome Enterprise `.msi` |

## Scenario

The lab is built on top of the domain configured in the previous module:

```text
fred.castillo
│
├── Active Directory
├── DNS
└── Group Policy
       │
       └── Windows Client
```

Policies are centrally managed from the Domain Controller and validated on the client machine.

---

# 1. Deploying Google Chrome through GPO

The first objective is to automate the installation of Google Chrome on domain computers.

## 1.1 Preparing the installer

A **Google Chrome Standalone Enterprise** package in `.msi` format is used.

The installer is placed in a shared folder on the server so that client computers can access it over the network.

The deployment path should use a **UNC network path**, for example:

```text
\\DC01\Software\Chrome\GoogleChromeStandaloneEnterprise64.msi
```

> The exact path may vary depending on the laboratory configuration.

## 1.2 Creating the GPO

From the Domain Controller, open:

```text
Group Policy Management
```

Create a new GPO named:

```text
Chrome installer
```

Configure the policy under:

```text
Computer Configuration
└── Policies
    └── Software Settings
        └── Software Installation
```

Add the `.msi` package using the corresponding network path.

The package is configured as:

```text
Assigned
```

This allows the software deployment to be managed centrally through Group Policy.

## 1.3 Updating Group Policy

After the GPO is linked to the appropriate scope, force a policy update:

```powershell
gpupdate /force
```

The client is then restarted or the user session is refreshed so that Windows can process the software deployment.

## 1.4 Validation

On the client computer, **Google Chrome is installed automatically** without manually running the installer.

---

# 2. Restricting Control Panel, CMD, and Regedit

The second part of the lab restricts access to several administrative tools.

A new GPO named:

```text
bloqueo administrativo cmd edit
```

is created.

## 2.1 Blocking Control Panel

The policy is configured under:

```text
User Configuration
└── Policies
    └── Administrative Templates
        └── Control Panel
```

The corresponding policy is enabled to prevent users from accessing Control Panel.

## 2.2 Blocking CMD

The Command Prompt restriction is configured under:

```text
User Configuration
└── Policies
    └── Administrative Templates
        └── System
```

The policy preventing access to the Command Prompt is enabled.

## 2.3 Blocking Regedit

A policy is also configured to prevent users from accessing **Registry Editor**.

This reduces the ability of standard users to directly modify sensitive Windows configuration settings.

## 2.4 Validation

The client is updated with:

```powershell
gpupdate /force
```

The following restrictions are then tested:

* Control Panel.
* Command Prompt.
* Registry Editor.

The system displays a message indicating that the requested action has been restricted by the administrator.

---

# 3. Time Synchronization through the Domain Controller

The third configuration uses a GPO named:

```text
NTP
```

The objective is to configure domain clients to use the Domain Controller as their time reference.

The policy is configured under:

```text
Computer Configuration
└── Policies
    └── Administrative Templates
        └── System
            └── Windows Time Service
                └── Time Providers
```

The required Windows Time Service policies are enabled to configure time synchronization on the clients.

Time synchronization is particularly important in an Active Directory environment because Kerberos authentication and other domain mechanisms depend on accurate system time.

---

# 4. Security Auditing

The final part of the laboratory uses a GPO named:

```text
auditorías de seguridad
```

The policy is configured under:

```text
Computer Configuration
└── Policies
    └── Windows Settings
        └── Security Settings
            └── Local Policies
                └── Audit Policy
```

The required auditing policies are enabled to record relevant security events.

## 4.1 Logon Auditing

Logon auditing is configured to record both successful and failed authentication attempts.

This allows administrators to identify valid and unsuccessful login attempts.

## 4.2 Process Tracking

Auditing related to **Process Tracking** is enabled to record events associated with process creation and execution.

This information can later be used as a source of evidence during security investigations.

## 4.3 System Events

Policies related to **System Events** are also enabled to record specific operating system events.

---

# 5. Validation through Event Viewer

The auditing configuration is validated using:

```text
Event Viewer
```

Previous security logs are cleared in order to make newly generated events easier to identify.

The following actions are then performed on the client:

1. Attempt to log in using an incorrect password.
2. Perform a successful login.
3. Refresh the security logs.
4. Review the newly generated events.

This confirms that authentication attempts generate the expected entries in the Security event log.

---

# 6. GPO Validation

In addition to visual verification, Group Policy can be validated from the client with:

```powershell
gpupdate /force
```

and:

```powershell
gpresult /r
```

`gpupdate` forces the client to refresh its policies, while `gpresult` can be used to verify which policies were applied to the computer or user.

---

# 7. Result

At the end of the laboratory, the domain environment contains several centralized policies:

```text
Domain Controller
│
├── Chrome installer
│      └── Automatic Chrome deployment
│
├── bloqueo administrativo cmd edit
│      ├── Control Panel restriction
│      ├── CMD restriction
│      └── Regedit restriction
│
├── NTP
│      └── Time synchronization
│
└── auditorías de seguridad
       ├── Logon
       ├── Process Tracking
       └── System Events
```

The policies were applied and validated on the client, including the restrictions and the generation of security audit events.

---

# Evidence

Screenshots for this laboratory are stored in:

```text
screenshots/
```

The evidence includes GPO configuration, policy application, and client-side validation.

## Video

**Lab demonstration:**
[Watch the video on YouTube](https://www.youtube.com/watch?v=hRDxHtdWJE8)

---

## What I Learned

This laboratory provided hands-on experience with **Group Policy** as a centralized administration mechanism for Windows systems within a domain environment.

The lab covered software deployment, access restrictions, Windows Time Service configuration, and security event auditing.

It also demonstrated the complete policy lifecycle:

```text
Create GPO
   ↓
Configure policy
   ↓
Link GPO
   ↓
Update policies
   ↓
Validate on client
   ↓
Verify results
```

---


## 👨‍💻 Autor

**Fred Castillo**  
*Information Security Technology Student*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Fred%20Castillo-0077B5?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/fredcastillo11/)
[![GitHub](https://img.shields.io/badge/GitHub-fredcastillo-100000?style=for-the-badge&logo=github)](https://github.com/fredcastillo)

---
