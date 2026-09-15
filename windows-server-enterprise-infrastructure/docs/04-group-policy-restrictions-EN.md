# 04 — Group Policy Restrictions

## Context

The project required desktop restrictions to be applied to four of the five departments while keeping Technology outside these restrictions.

The implemented policy was:

```text
Restricciones Escritorio - 4 Direcciones
```

---

## GPO Scope

The GPO was linked to:

```text
Dirección Administrativa
Dirección Legal
Dirección de Comunicaciones
Dirección de Gestión Humana
```

It was not linked to:

```text
Dirección de tecnología
```

This provided an unrestricted reference environment.

---

## Control Panel Restriction

The following policy path was configured:

```text
HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer
```

with:

```text
NoControlPanel = 1
```

This restricted access to Control Panel for affected users.

---

## Run Restriction

The same policy path was used with:

```text
NoRun = 1
```

This restricted the normal use of the Windows Run dialog.

---

## Command Prompt Restriction

The following policy path was configured:

```text
HKCU\Software\Policies\Microsoft\Windows\System
```

with:

```text
DisableCMD = 2
```

This restricted Command Prompt access.

---

## Wallpaper

A domain-hosted wallpaper was distributed using:

```text
\\WIN-IORAFMP55C9\NETLOGON\wallpaper.jpg
```

The configuration was:

```text
HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System

Wallpaper      = \\WIN-IORAFMP55C9\NETLOGON\wallpaper.jpg
WallpaperStyle = 10
TileWallpaper  = 0
```

The file was stored at:

```text
C:\Windows\SYSVOL\sysvol\fred.castillo\SCRIPTS\wallpaper.jpg
```

---

## Validation

The GPO was validated with a representative user from the Administrative department:

```text
User: AlanS12
Department: Administrativa
```

The following command was used:

```cmd
gpresult /r
```

The output confirmed that the expected policies were being applied to the test user.

---

## Previous Policy

The environment already contained an older administrative-restriction GPO from previous laboratory work.

Its existing links did not match the final project structure.

Instead of duplicating policies, the incorrect links were removed and the final project GPO was used for the required departments.

---

## Security Considerations

Group Policy provided centralized control over desktop restrictions through Active Directory.

Instead of configuring each client manually, the controls were associated with organizational units.

This improves:

- Centralized administration
- Auditing
- Consistency
- Future policy changes

---

## Evidence

```text
../../assets/04-gpo/
```

Suggested screenshots:

```text
01-gpo-management.png
02-gpo-linked-ous.png
03-registry-settings.png
04-wallpaper-policy.png
05-control-panel-blocked.png
06-run-blocked.png
07-cmd-blocked.png
08-gpresult.png
```

---

## Result

```text
✓ Control Panel restriction
✓ Run restriction
✓ Command Prompt restriction
✓ Centralized wallpaper
✓ OU-based targeting
✓ gpresult validation
✓ Technology excluded from the restrictive GPO
```