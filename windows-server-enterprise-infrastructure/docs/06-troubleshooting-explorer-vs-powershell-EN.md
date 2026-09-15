# 06 — Troubleshooting: Explorer vs PowerShell

## Context

During File Server validation, an issue occurred when attempting to access:

```text
\\WIN-IORAFMP55C9\Administrativa
```

through normal Windows Explorer navigation.

The test account was:

```text
FRED\AlanS12
```

and belonged to:

```text
GG_Administrativa
```

Explorer displayed:

```text
No se permite el acceso al recurso
```

The resource itself appeared to be correctly configured, so a layered troubleshooting process was used.

---

## Investigation Objective

The investigation focused on determining whether the issue was related to:

```text
Identity
Kerberos
Network
SMB
Share Permissions
NTFS Permissions
Security Policies
Explorer
```

Each layer was validated independently before changing configuration.

---

## 1. Identity Validation

The user identity was confirmed using:

```cmd
whoami
```

Expected result:

```text
fred\alans12
```

Group membership was checked with:

```cmd
whoami /groups
```

Membership in:

```text
GG_Administrativa
```

was confirmed.

---

## 2. Kerberos Validation

The command:

```cmd
klist
```

was used to inspect available Kerberos tickets.

A valid ticket for:

```text
cifs/WIN-IORAFMP55C9
```

was present.

This indicated that Kerberos authentication for the SMB service was working.

---

## 3. Resource Validation

The UNC path was tested directly:

```powershell
Test-Path "\\WIN-IORAFMP55C9\Administrativa"
```

Result:

```text
True
```

This showed that PowerShell could access the resource.

---

## 4. Share Permission Validation

Share permissions were checked with:

```powershell
Get-SmbShareAccess -Name "Administrativa"
```

The relevant permission was:

```text
GG_Administrativa → Change
```

This matched the intended department access model.

---

## 5. SMB Session Validation

The SMB session was inspected with:

```powershell
Get-SmbSession
```

A real SMB session was present using:

```text
Dialect: 3.1.1
```

Open files were also inspected using:

```powershell
Get-SmbOpenFile
```

and files associated with:

```text
AlanS12
```

were present.

This provided further evidence that SMB connectivity was functioning.

---

## 6. NTFS Permission Validation

The correct physical directory was:

```text
D:\Departamentos\Administrativa
```

It was checked with:

```cmd
icacls "D:\Departamentos\Administrativa"
```

An earlier test against:

```text
D:\Administrativa
```

was discarded because that was not the actual directory.

The correct path was:

```text
D:\Departamentos\Administrativa
```

---

## 7. Network Validation

SMB connectivity was tested on TCP port 445:

```powershell
Test-NetConnection WIN-IORAFMP55C9 -Port 445
```

Result:

```text
TcpTestSucceeded : True
```

This confirmed that SMB network connectivity was available.

---

## 8. Logon Policy Validation

The following security policy was checked:

```text
SeDenyNetworkLogonRight
```

It was not found to be applied to the user.

Therefore, this policy did not explain the observed behavior.

---

## 9. PowerShell File Operations

Several operations were performed directly against the resource:

```powershell
Test-Path
Get-ChildItem
New-Item
Set-Content
```

All tests succeeded.

This demonstrated that the user could:

- Detect the resource
- Enumerate its contents
- Create files/directories
- Write data

---

## 10. Explicit Explorer Launch

One of the most important tests was:

```powershell
Start-Process explorer.exe "\\WIN-IORAFMP55C9\Administrativa"
```

This successfully opened Explorer with the UNC path and displayed the actual contents of the resource.

---

## Analysis

At this stage two different behaviors had been established.

### Normal navigation

```text
Explorer
   ↓
\\WIN-IORAFMP55C9\Administrativa
   ↓
Access denied behavior
```

### Direct PowerShell / Explorer launch

```text
PowerShell
   ↓
Test-Path → True
Get-ChildItem → Successful
New-Item → Successful
Set-Content → Successful
Start-Process explorer.exe + UNC → Successful
```

The evidence supports the conclusion that the issue was **isolated to the normal Explorer access method**.

The investigation did not establish enough evidence to claim a specific internal Explorer bug or a particular mechanism such as SMB credential caching, UAC token behavior, or a double-hop problem.

---

## Troubleshooting Result

The investigation ruled out several potential layers:

```text
✓ Identity
✓ Group membership
✓ Kerberos
✓ SMB
✓ TCP 445
✓ Share permissions
✓ NTFS permissions
✓ Read/write operations
```

The remaining behavior was specific to the normal Explorer navigation method.

---

## Troubleshooting Methodology

The case followed a layered troubleshooting model:

```text
Identity
    ↓
Kerberos
    ↓
Network
    ↓
SMB
    ↓
Share Permissions
    ↓
NTFS
    ↓
Application Behavior
```

This approach reduced unnecessary configuration changes and helped preserve working components.

---

## Evidence

```text
../../assets/06-troubleshooting/
```

Suggested screenshots:

```text
01-explorer-error.png
02-whoami-groups.png
03-klist.png
04-test-path.png
05-smb-share-access.png
06-smb-session.png
07-smb-open-file.png
08-ntfs-permissions.png
09-port-445.png
10-powershell-file-access.png
11-explorer-explicit-path.png
12-final-analysis.png
```

---

## Final Result

The investigation demonstrated that:

```text
✓ The user identity was valid
✓ Kerberos was working
✓ SMB was working
✓ TCP 445 was reachable
✓ The expected permissions were configured
✓ PowerShell could access the resource
✓ Explorer could be explicitly launched with the UNC path
```

Therefore, the incident was documented as a behavior isolated to the normal Explorer access method rather than as a general File Server failure.