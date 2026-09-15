# Windows Server Enterprise Infrastructure

Infraestructura empresarial implementada sobre **Windows Server**, desarrollada como proyecto final de la asignatura **Seguridad de Sistemas Operativos**.

El proyecto integra servicios de infraestructura, Active Directory, DNS, DHCP, almacenamiento, servidor de archivos, políticas de grupo, administración de usuarios, redirección de carpetas, controles de seguridad, evaluación de vulnerabilidades y acceso a una infraestructura Linux en AWS.

> **Nota sobre la implementación:** la asignación académica original hacía referencia a Windows Server 2016 y Azure. La implementación final utilizó **Windows Server 2025** y **AWS EC2**, manteniendo los objetivos funcionales del proyecto.

---

## Descripción general

El objetivo fue construir una infraestructura de dominio funcional para una organización simulada, utilizando un controlador de dominio, una red de laboratorio aislada, almacenamiento dedicado, permisos por departamento y políticas de seguridad aplicadas mediante Active Directory y Group Policy.

El entorno también incorpora una evaluación de vulnerabilidades mediante Nessus y una máquina Linux en AWS accesible mediante autenticación SSH con clave.

### Principales componentes

- Windows Server 2025
- Active Directory Domain Services
- DNS
- DHCP
- Group Policy
- File Server
- NTFS permissions
- FSRM (File Server Resource Manager)
- Folder Redirection
- Password and account lockout policies
- VMware virtual networking
- Nessus vulnerability assessment
- AWS EC2
- Ubuntu Linux
- SSH key-based authentication
- PowerShell

---

## Arquitectura

La infraestructura utiliza una red de laboratorio aislada mediante **VMware VMnet2**.

```text
                         Physical Network
                        192.168.100.0/24
                               │
                               │
                    ┌─────────────────────┐
                    │ Windows Server 2025 │
                    │ WIN-IORAFMP55C9      │
                    │                     │
                    │ Ethernet0           │
                    │ 192.168.100.147     │
                    │                     │
                    │ Ethernet1           │
                    │ 192.168.200.2       │
                    │ DHCP / DNS / AD     │
                    └──────────┬──────────┘
                               │
                         VMware VMnet2
                      192.168.200.0/24
                               │
                               │ DHCP
                               ▼
                    ┌─────────────────────┐
                    │ Windows Client      │
                    │ ClienteRobles       │
                    │ 192.168.200.100     │
                    │ Domain: fred.castillo│
                    └─────────────────────┘
```

La red `192.168.200.0/24` fue utilizada como segmento de laboratorio para el cliente y los servicios internos del proyecto.

El controlador de dominio utilizó una dirección estática en `192.168.200.2`, mientras que el cliente obtuvo su dirección mediante DHCP.

---

## Active Directory

El dominio utilizado en el laboratorio fue:

```text
Domain: fred.castillo
NetBIOS: FRED
Domain Controller: WIN-IORAFMP55C9
```

Se utilizaron cinco unidades organizativas principales:

```text
Dirección Administrativa
Dirección de Comunicaciones
Dirección de Gestión Humana
Dirección de tecnología
Dirección Legal
```

Cada departamento contaba con usuarios y un grupo de seguridad específico:

```text
GG_Administrativa
GG_Comunicaciones
GG_GestionHumana
GG_Tecnologia
GG_Legal
```

Estos grupos fueron utilizados posteriormente para controlar el acceso a los recursos compartidos y aplicar restricciones específicas.

---

## Almacenamiento

El servidor utiliza dos discos virtuales:

```text
Disk 0 → Sistema operativo
Disk 1 → File Server
```

El segundo disco fue preparado como volumen NTFS:

```text
Drive: D:
Label: FileServer
Size: ~40 GB
File System: NTFS
```

La estructura principal del servidor de archivos es:

```text
D:\Departamentos\
├── Administrativa
├── Comunicaciones
├── GestionHumana
├── Legal
└── Tecnologia
```

Los accesos fueron controlados mediante una combinación de permisos de recurso compartido y permisos NTFS.

---

## Group Policy

Se implementó una GPO específica:

```text
Restricciones Escritorio - 4 Direcciones
```

La política fue vinculada a:

- Dirección Administrativa
- Dirección Legal
- Dirección de Comunicaciones
- Dirección de Gestión Humana

Las restricciones incluyeron:

```text
NoControlPanel = 1
NoRun          = 1
DisableCMD     = 2
```

También se configuró un fondo de escritorio institucional mediante una ruta del dominio:

```text
\\WIN-IORAFMP55C9\NETLOGON\wallpaper.jpg
```

El área de Tecnología se mantuvo fuera de esta GPO para conservar un usuario de referencia sin estas restricciones.

---

## Seguridad de cuentas

La política de contraseñas y bloqueo incluyó:

```text
Minimum password length: 7
Password complexity: Enabled
Account lockout threshold: 3 attempts
Lockout duration: 30 minutes
Observation window: 30 minutes
```

También se configuró la sincronización de tiempo mediante políticas de dominio.

---

## Folder Redirection

Para la redirección de documentos se utilizó:

```text
\\WIN-IORAFMP55C9\Usuarios$
```

con almacenamiento físico en:

```text
D:\Usuarios
```

La implementación se centró en la redirección de la carpeta **Documents**.

La configuración permite que los documentos del usuario sean almacenados en el servidor en lugar de depender exclusivamente del almacenamiento local del equipo cliente.

---

## File Server y FSRM

El servidor de archivos implementó controles específicos por departamento.

La configuración utilizó **File Server Resource Manager (FSRM)** para controlar determinados tipos de archivos.

### Tecnología

Sin File Screen restrictivo.

### Administrativa, Legal y Gestión Humana

Se permitieron principalmente:

- Office Files
- Text Files

y se bloquearon categorías como:

- Audio/Video
- Images
- Executables
- Compressed files
- Web pages
- Backup files
- Temporary files
- System files
- E-mail files

### Comunicaciones

Se permitió además contenido:

- Audio
- Video

manteniendo restricciones sobre otras categorías de archivos.

---

## Vulnerability Assessment

El entorno fue evaluado utilizando **Nessus** mediante un único escaneo realizado el:

```text
19 August 2026
```

Hosts analizados:

```text
192.168.200.2
192.168.200.100
```

Resumen del informe:

| Host | Critical | High | Medium | Low | Info |
|---|---:|---:|---:|---:|---:|
| 192.168.200.2 | 0 | 0 | 8 | 2 | 100 |
| 192.168.200.100 | 0 | 0 | 4 | 0 | 34 |
| **Total** | **0** | **0** | **12** | **2** | **134** |

El informe contiene **148 findings en total**. Esta cifra no debe interpretarse como 148 vulnerabilidades independientes.

Entre los hallazgos relevantes se identificaron:

- Certificados SSL no confiables
- Certificados SSL con hostname incorrecto
- TLS 1.0 habilitado
- TLS 1.1 habilitado
- SWEET32 / 3DES en RDP del cliente
- Exposición de información mediante DHCP
- ICMP Timestamp

El análisis completo está documentado en:

[`docs/07-vulnerability-assessment.md`](docs/07-vulnerability-assessment.md)

El informe original se encuentra en:

[`findings/nessus-report.pdf`](findings/nessus-report.pdf)

> El escaneo de Nessus debe considerarse una evaluación inicial. No se realizó un segundo escaneo posterior para validar remediaciones.

---

## Troubleshooting destacado

Uno de los incidentes más interesantes del proyecto ocurrió al intentar acceder desde Windows Explorer a:

```text
\\WIN-IORAFMP55C9\Administrativa
```

El usuario pertenecía al grupo correspondiente y la autenticación Kerberos y el acceso SMB estaban funcionando.

Las pruebas con PowerShell confirmaron:

```powershell
Test-Path
Get-ChildItem
New-Item
Set-Content
```

y también se pudo iniciar Explorer directamente mediante:

```powershell
Start-Process explorer.exe "\\WIN-IORAFMP55C9\Administrativa"
```

La investigación permitió aislar el problema al método de acceso utilizado por la navegación normal de Explorer, mientras que el recurso SMB, la identidad, Kerberos, permisos y conectividad continuaban funcionando.

La investigación completa se documenta aquí:

[`docs/06-troubleshooting-explorer-vs-powershell.md`](docs/06-troubleshooting-explorer-vs-powershell.md)

---

## AWS Cloud Access

Como parte del proyecto se implementó una instancia Linux en **AWS EC2**.

La máquina utilizó:

```text
Ubuntu Linux
SSH
Key-based authentication
```

El acceso se realizó utilizando una clave privada y sin autenticación mediante contraseña.

La configuración y el procedimiento de acceso se documentan en:

[`docs/08-cloud-ssh-access.md`](docs/08-cloud-ssh-access.md)

---

## Documentación técnica

| Documento | Contenido |
|---|---|
| [01 - Network Architecture](docs/01-network-architecture.md) | Diseño de red, VMware VMnet2, IPs y DHCP |
| [02 - Active Directory and Storage](docs/02-active-directory-and-storage.md) | AD, OUs, usuarios, grupos y discos |
| [03 - File Server and FSRM](docs/03-file-server-and-fsrm.md) | Shares, NTFS y restricciones FSRM |
| [04 - Group Policy Restrictions](docs/04-group-policy-restrictions.md) | Restricciones, wallpaper y GPO |
| [05 - Folder Redirection and Time Sync](docs/05-folder-redirection-and-time-sync.md) | Redirección de Documents y sincronización de tiempo |
| [06 - Explorer vs PowerShell Troubleshooting](docs/06-troubleshooting-explorer-vs-powershell.md) | Investigación del incidente SMB/Explorer |
| [07 - Vulnerability Assessment](docs/07-vulnerability-assessment.md) | Evaluación realizada con Nessus |
| [08 - Cloud SSH Access](docs/08-cloud-ssh-access.md) | AWS EC2 y acceso mediante SSH |

---

## Video demonstration

Demostración completa del proyecto:

[YouTube — Windows Server Enterprise Infrastructure](https://www.youtube.com/watch?v=uRUL2Djjtlo&list=PLTicoclDhFkeclmj8sIWeO94_mm0e5Qdu)

### Timestamps

| Tiempo | Sección |
|---|---|
| 01:22 | AD / DNS / DHCP / IP estática |
| 03:03 | Almacenamiento y discos |
| 03:43 | Cliente y DHCP |
| 05:14 | OUs y usuarios |
| 06:13 | GPO y restricciones |
| 08:32 | Folder Redirection |
| 10:55 | File Server y FSRM |
| 14:48 | Password / Lockout / NTP |
| 15:54 | Nessus |
| 16:58 | AWS Linux + SSH |

---

## Academic Requirements Mapping

| Requirement | Implementation |
|---|---|
| Active Directory | AD DS + Domain Controller |
| DNS | Integrated with Active Directory |
| DHCP | Scope `192.168.200.100–200` |
| Client via DHCP | `ClienteRobles` |
| Department OUs | 5 OUs |
| Department users | Users distributed across OUs |
| GPO restrictions | Administrative, Legal, Communications and HR |
| Wallpaper | Domain-based wallpaper |
| Document redirection | `Usuarios$` / Folder Redirection |
| File Server | Department shares |
| File restrictions | FSRM |
| Account lockout | 3 failed attempts |
| Password policy | Complexity + minimum length |
| Time synchronization | Domain-based configuration |
| Vulnerability assessment | Nessus |
| Cloud Linux access | AWS EC2 + SSH |

---

## Key Technical Decisions

### Isolated laboratory network

A dedicated VMware host-only segment was used for the client and DHCP environment:

```text
192.168.200.0/24
```

This separated the internal laboratory traffic from the physical network.

### Static address for the Domain Controller

The DC used:

```text
192.168.200.2
```

to maintain a stable address for core domain services.

### Layered troubleshooting

Troubleshooting was performed by validating the environment layer by layer:

```text
Identity
→ Kerberos
→ Network connectivity
→ SMB
→ Share permissions
→ NTFS permissions
→ Application behavior
```

This approach prevented changing working components without evidence.

---

## Repository Structure

```text
docs/       → Technical documentation
scripts/    → Reusable PowerShell and configuration scripts
assets/     → Screenshots and diagrams
findings/   → Security assessment and risk documentation
```

---

---

#### 👨‍💻 Autor

**Fred Castillo**  
*Estudiante de Tecnólogo en Seguridad Informática*  

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Fred%20Castillo-0077B5?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/fredcastillo11/)
[![GitHub](https://img.shields.io/badge/GitHub-fredcastillo-100000?style=for-the-badge&logo=github)](https://github.com/fredcastillo)
