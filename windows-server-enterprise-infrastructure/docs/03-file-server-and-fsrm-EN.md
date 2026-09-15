# 03 — File Server and FSRM

## Context

The project required a centralized file server where each department would have its own storage location and users would access only the resources assigned to their department.

The dedicated volume used for this purpose was:

```text
D:
Label: FileServer
```

The main directory was:

```text
D:\Departamentos
```

---

## Department Structure

Five department directories were created:

```text
D:\Departamentos\
├── Administrativa
├── Comunicaciones
├── GestionHumana
├── Legal
└── Tecnologia
```

Each directory was published as an SMB share using the department name.

Example:

```text
D:\Departamentos\Administrativa
        ↓
\\WIN-IORAFMP55C9\Administrativa
```

---

## Security Groups

Access was managed through the following Active Directory groups:

```text
GG_Administrativa
GG_Comunicaciones
GG_GestionHumana
GG_Legal
GG_Tecnologia
```

Using groups allowed department-based access management instead of assigning permissions individually to each user.

---

## Share Permissions

The shares were configured with administrative access for domain administrators and department-specific access for the corresponding security group.

Example:

```text
Administrativa
├── Domain Admins → Full Control
└── GG_Administrativa → Change
```

The same model was used for the other departments.

---

## NTFS Permissions

The physical directories were also protected using NTFS permissions.

For:

```text
D:\Departamentos\Administrativa
```

the final configuration included:

```text
FRED\GG_Administrativa
BUILTIN\Administrators
FRED\Domain Admins
NT AUTHORITY\SYSTEM
```

The corresponding department group had **Full Control** on the final configured directory.

Inheritance was also controlled to prevent unintended permission inheritance from higher-level directories.

---

## Permission Model

The relationship between identity and storage followed this model:

```text
User
   ↓
Department Group
   ↓
SMB Share Permission
   ↓
NTFS Permission
   ↓
Department Folder
```

Example:

```text
AlanS12
   ↓
GG_Administrativa
   ↓
\\WIN-IORAFMP55C9\Administrativa
   ↓
D:\Departamentos\Administrativa
```

---

## FSRM

**File Server Resource Manager (FSRM)** was used to enforce restrictions based on file type.

Native Windows file groups included:

```text
Audio and Video Files
Image Files
Office Files
E-mail Files
Executable Files
System Files
Compressed Files
Web Page Files
Text Files
Backup Files
Temporary Files
```

The File Screens were configured as **Active**, meaning restricted file types were blocked.

---

## Department Restrictions

### Administrative

Allowed:

```text
Office Files
Text Files
```

Restricted:

```text
Audio/Video
Images
E-mail
Executables
System files
Compressed files
Web pages
Backup files
Temporary files
```

### Legal

Allowed:

```text
Office Files
Text Files
```

Using the same restricted categories as Administrative.

### Human Resources

Allowed:

```text
Office Files
Text Files
```

Using the same restricted categories as Administrative and Legal.

### Communications

Allowed:

```text
Office Files
Text Files
Audio and Video Files
```

Other restricted categories remained blocked.

### Technology

No restrictive File Screen was applied.

This directory served as the reference environment without the FSRM restrictions applied to the other departments.

---

## Automation

PowerShell was used to support the File Server and FSRM configuration.

The department structure, shares, and permissions were organized using a department-based configuration.

The implementation used commands such as:

```powershell
New-SmbShare
icacls
New-FsrmFileScreen
```

Automation helped maintain a consistent configuration across the departments.

---

## Validation

The implementation was tested using domain users to verify access to the corresponding departmental resource.

A representative case was:

```text
User: AlanS12
Group: GG_Administrativa
Resource:
\\WIN-IORAFMP55C9\Administrativa
```

The detailed investigation of this access path is documented in:

[06 — Explorer vs PowerShell Troubleshooting](06-troubleshooting-explorer-vs-powershell.md)

---

## Security Considerations

Access control was implemented in multiple layers:

```text
Active Directory Groups
        +
SMB Share Permissions
        +
NTFS Permissions
        +
FSRM
```

This provided both departmental access isolation and file-type restrictions.

---

## Evidence

Screenshots for this document will be stored under:

```text
../../assets/03-file-server/
```

Suggested files:

```text
01-department-folders.png
02-share-permissions.png
03-ntfs-permissions.png
04-fsrm-console.png
05-file-screen.png
06-department-access.png
```

---

## Result

The implementation provided:

```text
✓ Five department folders
✓ SMB shares
✓ Department security groups
✓ NTFS permissions
✓ Active File Screens
✓ Department-specific file restrictions
✓ Unrestricted Technology reference environment
```