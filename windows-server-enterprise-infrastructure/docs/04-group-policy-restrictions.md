# 04 — Restricciones mediante Group Policy

## Contexto

El proyecto requería aplicar restricciones de escritorio a cuatro de los cinco departamentos, manteniendo Tecnología fuera de estas restricciones.

La política utilizada fue:

```text
Restricciones Escritorio - 4 Direcciones
```

---

## Alcance de la GPO

La GPO fue vinculada a:

```text
Dirección Administrativa
Dirección Legal
Dirección de Comunicaciones
Dirección de Gestión Humana
```

No fue vinculada a:

```text
Dirección de tecnología
```

Esto permitió mantener un entorno de referencia sin dichas restricciones.

---

## Restricción del Panel de Control

Se configuró:

```text
HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer
```

con:

```text
NoControlPanel = 1
```

Esta configuración restringe el acceso al Panel de Control para los usuarios afectados.

---

## Restricción de Run

En la misma ruta se configuró:

```text
NoRun = 1
```

El objetivo fue impedir el uso normal del cuadro de diálogo **Run**.

---

## Restricción de Command Prompt

Se configuró:

```text
HKCU\Software\Policies\Microsoft\Windows\System
```

con:

```text
DisableCMD = 2
```

Esto restringió el acceso al Command Prompt.

---

## Wallpaper

También se configuró un fondo de escritorio distribuido desde el dominio:

```text
\\WIN-IORAFMP55C9\NETLOGON\wallpaper.jpg
```

La configuración utilizada fue:

```text
HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System

Wallpaper      = \\WIN-IORAFMP55C9\NETLOGON\wallpaper.jpg
WallpaperStyle = 10
TileWallpaper  = 0
```

El archivo se almacenó físicamente en:

```text
C:\Windows\SYSVOL\sysvol\fred.castillo\SCRIPTS\wallpaper.jpg
```

---

## Validación

La aplicación de la GPO fue comprobada con un usuario del departamento de Administración:

```text
Usuario: AlanS12
Departamento: Administrativa
```

Se utilizó:

```cmd
gpresult /r
```

para verificar la aplicación de la política.

La validación confirmó que las políticas correspondientes estaban siendo aplicadas al usuario de prueba.

---

## Política anterior

El entorno contenía una GPO antigua de restricciones administrativas procedente de trabajos anteriores.

Dicha política tenía vínculos que no correspondían con la estructura final del proyecto.

En lugar de duplicar configuraciones, se eliminaron los vínculos incorrectos y se utilizó la nueva GPO para el proyecto.

---

## Consideraciones de seguridad

La utilización de Group Policy permitió centralizar los controles en Active Directory.

En lugar de configurar manualmente cada estación de trabajo, las restricciones se aplicaron según la OU a la que pertenecían los usuarios.

Esto facilita:

- Administración centralizada
- Auditoría
- Consistencia
- Modificación futura de políticas

---

## Evidencia

```text
../../assets/04-gpo/
```

Capturas sugeridas:

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

## Resultado

```text
✓ Restricción del Panel de Control
✓ Restricción de Run
✓ Restricción de Command Prompt
✓ Wallpaper centralizado
✓ Aplicación por OU
✓ Validación mediante gpresult
✓ Tecnología fuera de la GPO restrictiva
```