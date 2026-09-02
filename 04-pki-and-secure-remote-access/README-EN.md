🇬🇧 **English** | 🇪🇸 [Español](README.md)

<h1 align="center">PKI and Secure Remote Access</h1>

<p align="center">
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Windows%20Server-2025-0078D6?style=for-the-badge&logo=windows&logoColor=white" alt="Windows Server"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Ubuntu-Server-E95420?style=for-the-badge&logo=ubuntu&logoColor=white" alt="Ubuntu"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/SSH-Port%202275-000000?style=for-the-badge&logo=openssh&logoColor=white" alt="SSH"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/PKI-AD%20Certificate%20Services-2D72D9?style=for-the-badge" alt="PKI"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Certificate-Exportable%20%28PFX%29-9C27B0?style=for-the-badge" alt="Certificate"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/RDP-Secure%20Connection-4CAF50?style=for-the-badge" alt="RDP"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge" alt="Status"></a>
  <a href="https://www.youtube.com/watch?v=UHC0T9EKoEw"><img src="https://img.shields.io/badge/Demo%20Video-YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white" alt="Demo Video"></a>
</p>

## Description

Hands-on laboratory covering **SSH public-key authentication** and **Public Key Infrastructure (PKI)** in a Windows Server 2025 environment.

The laboratory is divided into two parts:

1. Configuring an Ubuntu Server to use SSH public-key authentication with a custom port.
2. Deploying a Certificate Authority on Windows Server 2025, creating a custom certificate template, issuing a certificate to a client, and associating the certificate with the RDP service.

## Objectives

* Change the SSH listening port.
* Generate an SSH key pair.
* Configure public-key authentication.
* Validate an SSH connection without using the account password.
* Install Active Directory Certificate Services.
* Configure a Certificate Authority.
* Create a custom certificate template.
* Allow private key export.
* Issue a certificate to a domain-joined client.
* Export the certificate as a `.pfx` file.
* Associate the certificate with the RDP service.
* Validate an RDP connection using the issued certificate.

## Environment

| Component       | Configuration                         |
| --------------- | ------------------------------------- |
| Windows Server  | Windows Server 2025                   |
| Domain          | `fred.castillo`                       |
| Server IP       | `192.168.100.147`                     |
| Linux Server    | Ubuntu Server                         |
| Windows Client  | Windows 10/11                         |
| PKI             | Active Directory Certificate Services |
| CA              | Certification Authority               |
| Remote services | SSH / RDP                             |
| Virtualization  | VMware Workstation                    |
| Student ID      | `2025-2175`                           |
| SSH Port        | `2275`                                |

## Architecture

```text
                           Windows Server 2025
                           192.168.100.147
                           Domain: fred.castillo
                                  │
                    ┌─────────────┴─────────────┐
                    │                           │
                    ▼                           ▼
             Active Directory            Certificate Authority
                                                │
                                                │ Issued certificate
                                                ▼
                                         Windows Client
                                         cliente roblex
                                                │
                                                │ RDP
                                                ▼
                                      Remote Desktop


Client / SSH Key
        │
        │ SSH :2275
        ▼
  Ubuntu Server
```

# Part 1 — SSH Public-Key Authentication

## 1. Change the SSH port

SSH uses port `22` by default.

This laboratory uses:

```text
2275
```

On the Ubuntu Server, open the OpenSSH configuration file:

```bash
sudo nano /etc/ssh/sshd_config
```

Locate:

```text
#Port 22
```

and change it to:

```text
Port 2275
```

Save the file and restart SSH:

```bash
sudo systemctl restart ssh
```

Verify that the service is listening:

```bash
sudo ss -tuln | grep 2275
```

The output should show port `2275` in a `LISTEN` state.

## 2. Generate an SSH key pair

On the client, generate a new key pair:

```bash
ssh-keygen
```

The process creates:

```text
Private key
Public key
```

The private key must remain protected on the client and must never be committed to the repository.

## 3. Configure `authorized_keys`

Display the public key:

```bash
cat ~/.ssh/id_rsa.pub
```

Copy the public key to the Ubuntu Server and add it to:

```text
~/.ssh/authorized_keys
```

If the `.ssh` directory does not exist:

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
```

Create or edit:

```bash
nano ~/.ssh/authorized_keys
```

Paste the public key and save the file.

Set the recommended permissions:

```bash
chmod 600 ~/.ssh/authorized_keys
```

## 4. Test SSH authentication

From the client:

```bash
ssh -p 2275 user@SERVER_IP
```

If the configuration is correct, the server will authenticate the user using the public key.

Authentication flow:

```text
Client
   │
   │ Private key
   ▼
Ubuntu Server :2275
   │
   │ Check authorized public key
   ▼
~/.ssh/authorized_keys
   │
   ▼
SSH Access
```

> Never publish the private key.

---

# Part 2 — Windows PKI Implementation

## 5. Install Active Directory Certificate Services

On Windows Server 2025, open:

```text
Server Manager
```

Select:

```text
Manage
└── Add Roles and Features
```

Use a role-based installation.

Select:

```text
Active Directory Certificate Services
```

Under role services, select:

```text
Certification Authority
```

Complete the installation and continue with the post-installation configuration.

**SHA-256** was selected as the hash algorithm during the laboratory configuration.

The CA is now ready to issue certificates.

## 6. Create a custom certificate template

Windows Server provides predefined certificate templates.

To create a custom template:

1. Open `certtmpl.msc`.
2. Locate:

```text
Web Server
```

3. Right-click the template and select the option to duplicate it.
4. Name the new template:

```text
Certificado exportable
```

### Allow private key export

Open the template properties and go to:

```text
Request Handling
```

Enable:

```text
Allow private key to be exported
```

This allows the certificate and its private key to be exported as a `.pfx` file.

### Configure enrollment permissions

Under the security settings, select:

```text
Authenticated Users
```

and grant:

```text
Enroll
```

This allows authenticated users to request certificates using the template.

## 7. Publish the template on the CA

Creating a template does not automatically make it available for certificate enrollment.

From the Certification Authority console:

```text
Certification Authority
└── Certificate Templates
```

select the option to issue a new certificate template and publish:

```text
Certificado exportable
```

The template is now available for enrollment.

---

# Part 3 — Request the Certificate from the Client

## 8. Open the certificate store

On the domain-joined Windows client, open:

```text
certlm.msc
```

Navigate to:

```text
Personal
└── Certificates
```

Start a new certificate request.

## 9. Select the certificate template

Select:

```text
Certificado exportable
```

Complete the additional certificate information required by the request.

The laboratory uses:

```text
Common Name
```

with:

```text
cliente roblex
```

Complete the request and verify that the certificate appears under:

```text
Personal
└── Certificates
```

---

# Part 4 — Export the Certificate

## 10. Export the certificate and private key

From:

```text
certlm.msc
└── Personal
    └── Certificates
```

right-click the certificate and select:

```text
All Tasks
└── Export
```

In the export wizard:

1. Choose the option to export the private key.
2. Select an appropriate format for a certificate that includes the private key.
3. Set a password to protect the exported file.
4. Save it as:

```text
.pfx
```

The `.pfx` file contains both the certificate and private key.

> **Do not commit the `.pfx` file to GitHub.** Do not publish its password.

---

# Part 5 — Associate the Certificate with RDP

## 11. Retrieve the certificate thumbprint

Open an elevated PowerShell session and query the local certificate store:

```powershell
Get-ChildItem Cert:\LocalMachine\My
```

Identify the certificate issued for the client and copy its:

```text
Thumbprint
```

The thumbprint identifies the specific certificate that will be used by the service.

## 12. Associate the certificate with RDP

Use the certificate thumbprint to associate the selected certificate with the Remote Desktop / Terminal Services service.

The intended relationship is:

```text
RDP
 │
 └── Certificate issued by the lab CA
```

Before applying the configuration, make sure the thumbprint corresponds to the correct certificate.

---

# Part 6 — Enable Remote Desktop

## 13. Enable RDP on the client

On the Windows client:

```text
Settings
└── System
    └── Remote Desktop
```

Enable **Remote Desktop**.

Make sure the account being used has permission to connect through RDP.

---

# Part 7 — Validate the Connection

## 14. Connect using RDP

From Windows Server 2025, launch:

```text
mstsc
```

Enter:

```text
cliente roblex
```

Provide the required credentials and establish the connection.

Once connected, inspect the connection security information.

Verify that the certificate associated with the connection corresponds to the certificate issued by the laboratory Certificate Authority.

The overall workflow is:

```text
Windows Server
       │
       │ Trust / certificate infrastructure
       ▼
Certificate Authority
       │
       │ Issues certificate
       ▼
Windows Client
       │
       │ Certificate assigned
       ▼
      RDP
       │
       ▼
Remote connection
```

# Validation

| Component   | Verification                        |
| ----------- | ----------------------------------- |
| SSH         | Service listening on `2275`         |
| SSH         | Public-key authentication           |
| AD CS       | Certification Authority installed   |
| Template    | `Certificado exportable` available  |
| Certificate | Issued to client                    |
| PFX         | Exported with private key           |
| RDP         | Certificate associated with service |
| Connection  | RDP validated from server           |

# Evidence

Screenshots for this laboratory should be stored in:

```text
screenshots/
```

Recommended evidence:

```text
01-ssh-port.png
02-ssh-key-generation.png
03-ssh-key-authentication.png
04-ad-cs-installation.png
05-certificate-template.png
06-certificate-enrollment.png
07-certificate-export.png
08-rdp-certificate.png
09-rdp-validation.png
```

## Video

[Watch the laboratory demonstration on YouTube](https://www.youtube.com/watch?v=UHC0T9EKoEw)

## Security

Do not commit any of the following to the repository:

* private keys;
* `.pfx` files;
* passwords;
* credentials;
* complete SSH keys;
* reusable cryptographic material.

---


## 👨‍💻 Autor

**Fred Castillo**  
*Information Security Technology Student*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Fred%20Castillo-0077B5?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/fredcastillo11/)
[![GitHub](https://img.shields.io/badge/GitHub-fredcastillo-100000?style=for-the-badge&logo=github)](https://github.com/fredcastillo)

---

