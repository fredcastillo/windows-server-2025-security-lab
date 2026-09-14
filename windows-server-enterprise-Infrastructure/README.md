🇪🇸 **Español** | 🇬🇧 [English](./README-EN.md)

# Windows Server Enterprise Infrastructure

[![Windows Server 2025](https://img.shields.io/badge/Windows%20Server-2025-0078D6?style=flat&logo=windows&logoColor=white)](#)
[![Role](https://img.shields.io/badge/Role-Domain%20Controller-2D72D9?style=flat)](#)
[![Services](https://img.shields.io/badge/Services-AD%20DS%20%7C%20DNS%20%7C%20DHCP-5E5E5E?style=flat)](#)
[![Virtualization](https://img.shields.io/badge/Virtualization-VMware-607078?style=flat&logo=vmware&logoColor=white)](#)
[![Forest](https://img.shields.io/badge/Forest-Single%20Forest-9C27B0?style=flat)](#)
[![OUs](https://img.shields.io/badge/OUs-5-FFB900?style=flat)](#)
[![Users](https://img.shields.io/badge/Users-25-4CAF50?style=flat)](#)
[![Cloud](https://img.shields.io/badge/Cloud-AWS%20EC2-FF9900?style=flat&logo=amazonaws&logoColor=white)](#)
[![Vulnerability Scan](https://img.shields.io/badge/Vulnerability%20Scan-Nessus-00C176?style=flat)](#)
[![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=flat)](#)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat)](#)
[![Demo Video](https://img.shields.io/badge/Demo%20Video-YouTube-FF0000?style=flat&logo=youtube&logoColor=white)](https://www.youtube.com/watch?v=uRUL2Djjtlo&list=PLTicoclDhFkeclmj8sIWeO94_mm0e5Qdu)

## 📖 Descripción General

Proyecto final desarrollado durante mi formación en Seguridad Informática: una infraestructura de TI empresarial simulada sobre Windows Server, para una empresa ficticia con cinco departamentos, cada uno con sus propias políticas de seguridad, restricciones de acceso y almacenamiento aislado.

El entorno reutiliza el mismo Domain Controller de mi laboratorio [windows-server-2025-security-lab](https://github.com/fredcastillo/windows-server-2025-security-lab), añadiendo DHCP, un File Server segmentado con FSRM, roaming profiles, directivas de restricción de escritorio, evaluación de vulnerabilidades y una VM Linux en la nube con acceso SSH.

Este repositorio documenta las decisiones de arquitectura, los procedimientos, y los problemas reales que surgieron durante la implementación junto con su diagnóstico — no solo la configuración final.

> **Plataforma principal:** Windows Server 2025 **Virtualización:** VMware Workstation **Cloud:** AWS EC2

## Aporte profesional

Diseño de red y toma de decisiones de arquitectura, administración de Active Directory y Group Policy, seguridad de File Server por capas — y troubleshooting metódico real: descartar causas capa por capa (identidad → autenticación → transporte → permisos → aplicación) en vez de reconfigurar al azar. El caso documentado en [`docs/06`](./docs/06-troubleshooting-explorer-vs-powershell.md) es un ejemplo real de esa metodología.

## Principales temas

- Active Directory Domain Services (reutilizado)
- DNS y DHCP
- Segundo disco dedicado a File Server
- Unidades Organizativas y grupos de seguridad
- Directivas de Grupo — restricciones de escritorio y wallpaper corporativo
- Roaming Profile / Folder Redirection
- File Server segmentado con permisos NTFS y FSRM
- Políticas de contraseña y bloqueo de cuenta
- Evaluación de vulnerabilidades con Nessus
- Máquina virtual Linux en AWS con acceso SSH por clave

## Entorno

```
            Windows Server 2025
          ┌─────────────────────┐
          │ Active Directory    │
          │ DNS · DHCP          │
          │ Directivas de Grupo │
          │ File Server / FSRM  │
          └──────────┬──────────┘
                     │
          Red de laboratorio aislada
             (Host-only, VMnet2)
                     │
              Cliente Windows
              (IP por DHCP)
                     │
            Evaluación de seguridad
                     │
                  Nessus

  Además: VM Linux en AWS EC2, accesible
  por SSH desde el Domain Controller.
```

## Documentación técnica

| # | Documento | Temas principales |
|---|---|---|
| 01 | [Arquitectura de red](./docs/01-network-architecture.md) | Decisión de arquitectura, DHCP, VMnet2, IP duplicada |
| 02 | [Active Directory y almacenamiento](./docs/02-active-directory-and-storage.md) | Auditoría inicial, segundo disco, grupos, política de contraseñas |
| 03 | [File Server y FSRM](./docs/03-file-server-and-fsrm.md) | Shares, permisos NTFS, restricción por tipo de archivo |
| 04 | [Directivas de restricción](./docs/04-group-policy-restrictions.md) | CMD/RUN/Panel de Control, wallpaper corporativo |
| 05 | [Folder Redirection y sincronización de hora](./docs/05-folder-redirection-and-time-sync.md) | Roaming profile, incidente de Kerberos |
| 06 | [Troubleshooting: Explorer vs PowerShell](./docs/06-troubleshooting-explorer-vs-powershell.md) | Diagnóstico de acceso denegado, metodología por capas |
| 07 | [Evaluación de vulnerabilidades](./docs/07-vulnerability-assessment.md) | Nessus, hallazgos, remediación |
| 08 | [VM Linux en la nube y SSH](./docs/08-cloud-ssh-access.md) | AWS EC2, autenticación por clave |

## Estructura del repositorio

```
windows-server-enterprise-infrastructure/
│
├── README.md
├── README-EN.md
│
├── docs/
│   ├── README.md
│   ├── 01-network-architecture.md
│   ├── 02-active-directory-and-storage.md
│   ├── 03-file-server-and-fsrm.md
│   ├── 04-group-policy-restrictions.md
│   ├── 05-folder-redirection-and-time-sync.md
│   ├── 06-troubleshooting-explorer-vs-powershell.md
│   ├── 07-vulnerability-assessment.md
│   └── 08-cloud-ssh-access.md
│
├── scripts/
│   └── ...
│
└── assets/
    └── ...
```

## Documentación

Cada documento técnico en `docs/` sigue la misma estructura: contexto, qué se hizo, qué problema apareció (si lo hubo), cómo se diagnosticó, y cómo se resolvió.

El objetivo es documentar no solamente cómo se realizó una configuración, sino también cómo se comprobó su funcionamiento — y qué se hizo cuando algo no funcionó a la primera.

## Validación realizada

- `gpresult /r`: GPOs correctas aplicadas por usuario y OU.
- Control positivo/negativo: usuario restringido vs. usuario de Tecnología sin restricciones.
- File Screens: documentos aceptados, tipos prohibidos rechazados según cada departamento.
- Aislamiento SMB/NTFS confirmado por departamento.

## Capturas de pantalla

> Agregar evidencias en `./assets/` y enlazarlas aquí.

## Video de demostración

📺 [Ver el video completo](https://www.youtube.com/watch?v=uRUL2Djjtlo&list=PLTicoclDhFkeclmj8sIWeO94_mm0e5Qdu)

| Tiempo | Sección |
|---|---|
| [01:22](https://www.youtube.com/watch?v=uRUL2Djjtlo&t=82) | Infraestructura base: AD, DNS, DHCP e IP estática del servidor |
| [03:03](https://www.youtube.com/watch?v=uRUL2Djjtlo&t=183) | Gestión de almacenamiento: los dos discos del servidor |
| [03:43](https://www.youtube.com/watch?v=uRUL2Djjtlo&t=223) | Cliente unido al dominio, IP dinámica por DHCP |
| [05:14](https://www.youtube.com/watch?v=uRUL2Djjtlo&t=314) | Las 5 Unidades Organizativas y sus usuarios |
| [06:13](https://www.youtube.com/watch?v=uRUL2Djjtlo&t=373) | GPO: bloqueo de Panel de Control/CMD, wallpaper institucional |
| [08:32](https://www.youtube.com/watch?v=uRUL2Djjtlo&t=512) | Roaming Profiles y permisos NTFS exclusivos |
| [10:55](https://www.youtube.com/watch?v=uRUL2Djjtlo&t=655) | File Server segmentado por OU + restricción de tipos de archivo (FSRM) |
| [14:48](https://www.youtube.com/watch?v=uRUL2Djjtlo&t=888) | Políticas de contraseña, bloqueo de cuenta y NTP |
| [15:54](https://www.youtube.com/watch?v=uRUL2Djjtlo&t=954) | Análisis de vulnerabilidades con Nessus |
| [16:58](https://www.youtube.com/watch?v=uRUL2Djjtlo&t=1018) | VM Linux en AWS y acceso SSH por clave |

## Notas

Las instrucciones académicas originales de este proyecto hacían referencia a **Windows Server 2016 R2** y a **Microsoft Azure**. Sin embargo, esta implementación fue realizada utilizando **Windows Server 2025** y **AWS EC2**, ambas sustituciones aprobadas por el profesor.

El Domain Controller mantiene una **IP estática** (no una reserva de DHCP): es la práctica recomendada para cualquier controlador de dominio, ya que este mismo servidor presta el servicio DHCP.

## Estado

Completado.

Los 10 requisitos del proyecto están implementados y validados. La documentación en `docs/` incluye el proceso de diagnóstico completo de los problemas reales encontrados durante la implementación, no solo las configuraciones finales.

---

#### 👨‍💻 Autor

**Fred Castillo**
*Estudiante de Tecnólogo en Seguridad Informática*
*Aspirante a Red Team | Seguridad Ofensiva*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Fred%20Castillo-0077B5?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/fredcastillo11/)
[![GitHub](https://img.shields.io/badge/GitHub-fredcastillo-100000?style=for-the-badge&logo=github)](https://github.com/fredcastillo)
