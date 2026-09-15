# 03 — Servidor de Archivos y FSRM

## Contexto

El proyecto requería un servidor de archivos centralizado donde cada departamento tuviera su propio espacio de almacenamiento y los usuarios accedieran únicamente a los recursos correspondientes a su departamento.

Para esta función se utilizó el volumen:

```text
D:
Etiqueta: FileServer
```

La estructura principal se ubicó en:

```text
D:\Departamentos
```

---

## Estructura de departamentos

Se crearon cinco carpetas departamentales:

```text
D:\Departamentos\
├── Administrativa
├── Comunicaciones
├── GestionHumana
├── Legal
└── Tecnologia
```

Cada carpeta fue publicada como un recurso compartido SMB utilizando el mismo nombre del departamento.

Ejemplo:

```text
D:\Departamentos\Administrativa
        ↓
\\WIN-IORAFMP55C9\Administrativa
```

---

## Grupos de seguridad

El acceso se gestionó mediante los grupos de Active Directory:

```text
GG_Administrativa
GG_Comunicaciones
GG_GestionHumana
GG_Legal
GG_Tecnologia
```

El uso de grupos permitió asignar permisos por departamento sin depender de permisos individuales para cada usuario.

---

## Permisos de los recursos compartidos

Los recursos compartidos fueron configurados con acceso administrativo para los administradores del dominio y acceso específico para el grupo correspondiente.

Por ejemplo:

```text
Administrativa
├── Domain Admins → Full Control
└── GG_Administrativa → Change
```

El mismo modelo se utilizó para los demás departamentos.

---

## Permisos NTFS

Además de los permisos del recurso compartido, los directorios físicos fueron protegidos mediante NTFS.

Para el directorio:

```text
D:\Departamentos\Administrativa
```

la configuración final incluía:

```text
FRED\GG_Administrativa
BUILTIN\Administrators
FRED\Domain Admins
NT AUTHORITY\SYSTEM
```

El grupo departamental tenía **Full Control** sobre el directorio final configurado.

La herencia también fue controlada para evitar que permisos no deseados fueran heredados desde directorios superiores.

---

## Modelo de permisos

La relación entre identidad y almacenamiento siguió el siguiente modelo:

```text
Usuario
   ↓
Grupo de departamento
   ↓
Permiso del recurso SMB
   ↓
Permiso NTFS
   ↓
Carpeta del departamento
```

Por ejemplo:

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

Se utilizó **File Server Resource Manager (FSRM)** para aplicar restricciones según el tipo de archivo.

Se utilizaron grupos nativos de archivos de Windows, entre ellos:

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

Los File Screens se configuraron como **Active**, por lo que los tipos de archivo restringidos eran bloqueados.

---

## Restricciones por departamento

### Administrativa

Permitidos:

```text
Office Files
Text Files
```

Restringidos:

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

Permitidos:

```text
Office Files
Text Files
```

Con las mismas categorías restringidas utilizadas para Administrativa.

### Gestión Humana

Permitidos:

```text
Office Files
Text Files
```

Con las mismas categorías restringidas utilizadas para Administrativa y Legal.

### Comunicaciones

Permitidos:

```text
Office Files
Text Files
Audio and Video Files
```

Se mantuvieron restricciones sobre otras categorías.

### Tecnología

No se aplicó un File Screen restrictivo.

Esta carpeta funcionó como referencia para un entorno sin las restricciones de FSRM utilizadas en los demás departamentos.

---

## Automatización

La configuración del File Server y FSRM se apoyó en PowerShell.

La creación de las carpetas, recursos compartidos y permisos se organizó utilizando una estructura por departamentos.

El proceso empleó comandos como:

```powershell
New-SmbShare
icacls
New-FsrmFileScreen
```

La automatización permitió repetir la configuración siguiendo el mismo modelo para los distintos departamentos.

---

## Validación

Se realizaron pruebas utilizando usuarios reales del dominio para verificar el acceso al recurso correspondiente.

Un caso representativo fue:

```text
Usuario: AlanS12
Grupo: GG_Administrativa
Recurso:
\\WIN-IORAFMP55C9\Administrativa
```

La investigación detallada de este acceso se encuentra en:

[06 — Troubleshooting Explorer vs PowerShell](06-troubleshooting-explorer-vs-powershell-ES.md)

---

## Consideraciones de seguridad

El control de acceso se implementó en varias capas:

```text
Active Directory Groups
        +
SMB Share Permissions
        +
NTFS Permissions
        +
FSRM
```

Esto permitió separar los recursos por departamento y controlar, además del acceso, los tipos de archivos permitidos.

---

## Evidencia

Las capturas de este documento se almacenarán en:

```text
../../assets/03-file-server/
```

Archivos sugeridos:

```text
01-department-folders.png
02-share-permissions.png
03-ntfs-permissions.png
04-fsrm-console.png
05-file-screen.png
06-department-access.png
```

---

## Resultado

La implementación proporcionó:

```text
✓ Cinco carpetas departamentales
✓ Recursos compartidos SMB
✓ Grupos de seguridad por departamento
✓ Permisos NTFS
✓ File Screens activos
✓ Restricciones por tipo de archivo
✓ Entorno sin File Screen restrictivo para Tecnología
```