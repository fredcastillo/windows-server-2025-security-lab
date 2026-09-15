# 02 — Active Directory y Almacenamiento

## Contexto

El proyecto requería un entorno Windows Server con **Active Directory**, unidades organizativas, usuarios, grupos de seguridad, políticas de contraseñas, bloqueo de cuentas y almacenamiento dedicado para los servicios de archivos.

La implementación final utilizó:

```text
Sistema operativo: Windows Server 2025
Dominio: fred.castillo
NetBIOS: FRED
Domain Controller: WIN-IORAFMP55C9
```

---

## Entorno de Active Directory

Active Directory Domain Services y DNS ya estaban disponibles en el servidor y formaron la base de la infraestructura final.

Se utilizaron cinco unidades organizativas principales para representar los departamentos:

```text
Dirección Administrativa
Dirección de Comunicaciones
Dirección de Gestión Humana
Dirección de tecnología
Dirección Legal
```

También existían otros contenedores y OUs en el entorno, entre ellos:

```text
Domain Controllers
Domain PC's
empresa
```

Las cinco OUs departamentales anteriores fueron las utilizadas para representar la estructura organizacional requerida por el proyecto final.

---

## Usuarios

El entorno contaba con cinco usuarios por departamento:

```text
5 departamentos × 5 usuarios = 25 usuarios
```

Para las demostraciones finales se utilizaron dos usuarios representativos de cada departamento.

Esto permitió realizar pruebas de:

- Membresía de grupos
- Aplicación de GPO
- Acceso a archivos
- Folder Redirection
- Autenticación
- Restricciones por departamento

---

## Grupos de seguridad

Se crearon cinco grupos de seguridad:

```text
GG_Tecnologia
GG_Administrativa
GG_Legal
GG_Comunicaciones
GG_GestionHumana
```

Cada grupo fue asociado con su departamento correspondiente.

Posteriormente fueron utilizados para:

- Permisos del File Server
- Acceso a recursos SMB
- Aislamiento entre departamentos
- Aplicación de políticas

El uso de grupos permitió administrar los permisos por departamento en lugar de asignarlos individualmente a cada usuario.

---

## Política de contraseñas y bloqueo

La configuración final incluyó:

```text
Longitud mínima de contraseña: 7
Complejidad de contraseña: Habilitada
Umbral de bloqueo: 3 intentos fallidos
Duración del bloqueo: 30 minutos
Ventana de observación: 30 minutos
```

Inicialmente el umbral de bloqueo estaba configurado en:

```text
0
```

lo que deshabilitaba el bloqueo.

Fue cambiado a:

```text
3
```

para cumplir con el requisito de seguridad del proyecto.

La configuración final se aplicó mediante:

```powershell
Set-ADDefaultDomainPasswordPolicy `
    -Identity fred.castillo `
    -LockoutThreshold 3 `
    -LockoutDuration "00:30:00" `
    -LockoutObservationWindow "00:30:00"
```

---

## Arquitectura de almacenamiento

El servidor fue configurado con dos discos virtuales:

```text
Disk 0 → Sistema operativo
Disk 1 → File Server
```

El segundo disco proporcionó almacenamiento dedicado para los recursos compartidos de los departamentos y los datos de usuarios.

### Disk 1

```text
Capacidad: aproximadamente 40 GB
Estilo de partición: GPT
Letra: D:
Sistema de archivos: NTFS
Etiqueta: FileServer
```

El disco fue preparado mediante PowerShell:

```powershell
Initialize-Disk -Number 1 -PartitionStyle GPT

New-Partition `
    -DiskNumber 1 `
    -UseMaximumSize `
    -DriveLetter D

Format-Volume `
    -DriveLetter D `
    -FileSystem NTFS `
    -NewFileSystemLabel "FileServer" `
    -Confirm:$false
```

---

## Problema con la letra de unidad

Durante la configuración del almacenamiento, el segundo disco no podía utilizar inicialmente la letra `D:` porque el dispositivo de CD/DVD ya estaba utilizando esa letra.

El dispositivo óptico fue reasignado para permitir que el nuevo volumen del File Server utilizara:

```text
D:
```

Después del cambio, el disco fue formateado como NTFS y etiquetado:

```text
FileServer
```

---

## Estructura del File Server

El volumen dedicado sirvió como base para los recursos departamentales:

```text
D:\Departamentos\
```

La estructura final fue:

```text
D:\Departamentos\
├── Administrativa
├── Comunicaciones
├── GestionHumana
├── Legal
└── Tecnologia
```

También se creó una ubicación independiente para el almacenamiento de documentos de usuarios:

```text
D:\Usuarios
```

Este directorio se utilizó posteriormente para Folder Redirection.

---

## Relación entre Active Directory y almacenamiento

La infraestructura conectó las identidades de Active Directory con los permisos de almacenamiento.

El modelo fue:

```text
Usuario
   ↓
Departamento
   ↓
Grupo de seguridad
   ↓
Recurso compartido SMB
   ↓
Permisos NTFS
```

Ejemplo:

```text
AlanS12
   ↓
GG_Administrativa
   ↓
Recurso Administrativa
   ↓
D:\Departamentos\Administrativa
```

Este modelo se utilizó como base para el control de acceso a los recursos departamentales.

---

## Infraestructura existente

Algunos componentes ya estaban presentes antes de la integración final del proyecto.

Entre ellos:

- Active Directory Domain Services
- DNS
- Cinco OUs departamentales
- Usuarios existentes
- WSUS
- Microsoft LAPS
- GPO relacionada con NTP
- Otras políticas de laboratorio

La implementación final no recreó innecesariamente componentes que ya estaban funcionando.

En cambio, se extendió la infraestructura existente con los componentes necesarios para el proyecto.

---

## Cambios realizados

Las principales incorporaciones o modificaciones relacionadas con el proyecto fueron:

```text
✓ DHCP
✓ Segunda interfaz de red
✓ Integración con VMware VMnet2
✓ Almacenamiento dedicado D:
✓ Grupos de seguridad departamentales
✓ File Server
✓ FSRM
✓ Permisos departamentales
✓ GPO de restricciones
✓ GPO de Folder Redirection
✓ Configuración de bloqueo de cuentas
```

---

## Validación

La configuración de Active Directory fue validada mediante las herramientas administrativas y PowerShell.

Entre las validaciones utilizadas se encuentran:

```powershell
Get-ADUser
Get-ADGroup
Get-ADOrganizationalUnit
Get-ADDefaultDomainPasswordPolicy
```

El entorno también fue validado desde el cliente Windows después de su incorporación al dominio.

La detección del Domain Controller se comprobó mediante:

```cmd
nltest /dsgetdc:fred.castillo
```

---

## Consideraciones de seguridad

La estructura de Active Directory utilizó grupos para gestionar los permisos en lugar de depender de asignaciones individuales siempre que fue posible.

Esto facilita la administración y auditoría del acceso.

La política de contraseñas y bloqueo también incorporó controles básicos contra intentos repetidos de autenticación.

No deben almacenarse en este repositorio:

- Contraseñas
- Claves privadas
- Tokens
- Credenciales
- Otros secretos

---

## Evidencia

Las capturas previstas para este documento se almacenarán en:

```text
../../assets/02-active-directory/
```

Archivos sugeridos:

```text
01-domain-configuration.png
02-organizational-units.png
03-users.png
04-security-groups.png
05-password-policy.png
06-storage-disks.png
07-file-server-volume.png
```

---

## Resultado

La configuración final proporcionó:

```text
✓ Administración de identidades mediante dominio
✓ Cinco OUs departamentales
✓ Grupos de seguridad por departamento
✓ 25 usuarios existentes
✓ Usuarios representativos para pruebas
✓ Complejidad de contraseñas
✓ Bloqueo después de tres intentos fallidos
✓ Almacenamiento dedicado para File Server
✓ Volumen D: en NTFS
```

Estos componentes proporcionaron la base de identidad y almacenamiento necesaria para los demás servicios del proyecto.