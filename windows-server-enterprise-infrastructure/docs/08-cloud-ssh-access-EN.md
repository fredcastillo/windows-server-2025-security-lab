# 08 — Cloud SSH Access

## Context

The final project required the integration of a Linux machine in a cloud environment and remote access using certificate- or key-based authentication.

The final implementation used:

```text
Cloud Provider: AWS
Service: EC2
Operating System: Ubuntu Linux
Protocol: SSH
Authentication: Private Key
```

AWS was used instead of Azure while preserving the functional objective of the assignment.

---

## Architecture

The Linux system was deployed as an EC2 instance.

Access was performed using a private:

```text
.pem
```

key.

The authentication flow was:

```text
Windows environment
       │
       │ SSH
       │
       ▼
AWS EC2
Ubuntu Linux
```

Password-based SSH authentication was not used for the demonstrated connection.

---

## EC2 Instance

The instance ran Ubuntu Linux.

Its configuration followed the laboratory design used for the project and allowed SSH access from the Windows environment used during the demonstration.

---

## Security Group

SSH access was provided through:

```text
TCP/22
```

The instance Security Group allowed the SSH traffic necessary for the demonstration.

The configuration was intended to permit the required source rather than unnecessarily opening unrelated ports.

---

## Private Key

Authentication used a private:

```text
.pem
```

key.

The key permissions on Windows were restricted using commands such as:

```powershell
icacls C:\path\key.pem /inheritance:r
icacls C:\path\key.pem /grant:r "$($env:USERNAME):(R)"
```

The private key must never be committed to the repository.

---

## SSH Connection

The Ubuntu account used for the connection was:

```text
ubuntu
```

The connection command was:

```powershell
ssh -i C:\path\key.pem ubuntu@<EC2-public-IP>
```

The actual public address used during the laboratory demonstration should not be permanently documented when it is no longer necessary.

---

## Validation

The objective was to demonstrate that the Windows environment could establish an SSH session with the cloud-hosted Linux system.

The validation process was:

```text
1. Make the private key available.
2. Verify key permissions.
3. Execute SSH.
4. Authenticate using the private key.
5. Obtain a shell on Ubuntu.
```

The cloud access demonstration was included in the final project video.

---

## Security Considerations

Key-based authentication avoids depending on a password for the demonstrated SSH connection.

The private key must never be stored in:

```text
GitHub
README files
Public scripts
Screenshots
Issues
```

The repository should also never contain:

- AWS access keys
- AWS secret keys
- Tokens
- Passwords
- Other credentials

Public IP information should only be documented when there is a clear reason to do so.

---

## AWS Integration

The AWS component demonstrated that the project could connect its local Windows infrastructure with an external Linux cloud environment.

The resulting flow was:

```text
Windows Infrastructure
        │
        │ SSH
        │
        ▼
AWS EC2
        │
        ▼
Ubuntu Linux
```

---

## Evidence

Screenshots will be stored under:

```text
../../assets/08-aws/
```

Suggested files:

```text
01-ec2-instance.png
02-security-group-ssh.png
03-private-key-permissions.png
04-ssh-command.png
05-ssh-authenticated.png
06-ubuntu-validation.png
```

---

## Repository Security

Private keys should be excluded using `.gitignore`:

```gitignore
*.pem
*.key
.env
```

This protects the repository from accidentally publishing credentials.

---

## Result

The implementation demonstrated:

```text
✓ AWS EC2 Linux instance
✓ Ubuntu Linux
✓ SSH connectivity
✓ Private-key authentication
✓ Cloud integration
✓ Protection of sensitive credentials
```

The cloud component complemented the local Windows infrastructure with an external Linux environment.