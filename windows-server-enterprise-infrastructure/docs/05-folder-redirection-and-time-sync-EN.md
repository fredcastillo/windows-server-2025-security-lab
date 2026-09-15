# 05 — Folder Redirection and Time Synchronization

## Context

The project required centralized user document storage and consistent time synchronization within the domain.

User documents were stored through:

```text
\\WIN-IORAFMP55C9\Usuarios$
```

with the physical storage location:

```text
D:\Usuarios
```

---

## Usuarios$ Share

The `Usuarios$` share was configured as a hidden SMB share.

Share permissions included:

```text
Domain Admins → Full Control
Authenticated Users → Change
```

The root NTFS permissions were configured to support the creation and management of individual user directories.

The permission model included:

```text
Authenticated Users
CREATOR OWNER
Domain Admins
SYSTEM
```

---

## Folder Redirection

The implemented GPO was:

```text
Roaming - Redireccion de Documentos
```

The implementation specifically redirected:

```text
Documents
```

The final path format was:

```text
\\WIN-IORAFMP55C9\Usuarios$\<user>\Documents
```

Example:

```text
\\WIN-IORAFMP55C9\Usuarios$\AlanS12\Documents
```

This was **Folder Redirection for Documents**, not a complete roaming user profile.

---

## Directory Creation

The configuration allowed the user's corresponding directory to be created when the policy was processed.

The expected structure was:

```text
D:\Usuarios\
└── AlanS12\
    └── Documents\
```

---

## Access Model

The design aimed to keep user documents separated by account:

```text
User
   │
   ▼
User's Documents folder
   │
   └── Read / Write
```

Root-share permissions were combined with permissions on the individual user directories.

---

## Validation

Validation was performed after Group Policy processing.

The procedure consisted of:

```text
1. Sign in with a domain user.
2. Allow Group Policy to process.
3. Open Documents.
4. Verify server-side redirection.
5. Verify the corresponding directory under D:\Usuarios.
```

The expected destination was:

```text
\\WIN-IORAFMP55C9\Usuarios$\<user>\Documents
```

---

## Time Synchronization

The project also required consistent system time across the domain environment.

During testing, a noticeable difference was observed between the date and time displayed by the server and client.

The investigation showed that a significant portion of the apparent difference was related to the configured time zones.

After correction, the actual UTC difference was reduced to only a few seconds.

---

## Windows Time Service

The current time-service state was inspected using:

```cmd
w32tm /query /status
```

The system was also resynchronized using:

```cmd
w32tm /resync /rediscover
```

This forced the system to rediscover its time source and synchronize.

---

## Active Directory Dependency

The time issue affected domain operations.

At one point:

```cmd
gpupdate /force
```

failed because of the time difference between the client and the domain environment.

After synchronization was corrected, Group Policy processing completed successfully again.

This demonstrated the importance of consistent time for Active Directory and Kerberos-related operations.

---

## Administrative Permissions

When:

```cmd
w32tm /resync
```

was executed under a standard account, Windows returned an access-denied response.

This was expected because certain Windows Time operations require administrative privileges.

---

## Troubleshooting Note

VMware host-to-guest time synchronization was considered as a possible contributing factor.

However, it was not conclusively established as the root cause during the documented investigation.

The confirmed result was that correcting the time state and resynchronizing the Windows Time service restored normal domain operations.

---

## Security and Availability Considerations

Centralized document storage improves administrative control over user data and reduces dependence on local storage.

Time synchronization is also a dependency for domain availability because significant clock differences can interfere with Kerberos authentication and other domain operations.

---

## Evidence

```text
../../assets/05-folder-redirection/
```

Suggested screenshots:

```text
01-usuarios-share.png
02-folder-redirection-gpo.png
03-redirected-documents.png
04-user-folder-on-server.png
05-w32tm-status.png
06-time-sync-validation.png
```

---

## Result

```text
✓ Centralized Documents storage
✓ Hidden Usuarios$ share
✓ Per-user directory structure
✓ GPO-based Folder Redirection
✓ Domain time synchronization
✓ Recovery from time-related domain issues
```