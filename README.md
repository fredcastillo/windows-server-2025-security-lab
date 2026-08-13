🇪🇸 **Español** | 🇬🇧 [English](README-EN.md)

# Windows Server Security Lab

![Windows Server 2025](https://img.shields.io/badge/Windows%20Server-2025-0078D6?style=flat&logo=windows&logoColor=white)
![Role](https://img.shields.io/badge/Role-Domain%20Controller-2D72D9?style=flat)
![Services](https://img.shields.io/badge/Services-AD%20DS%20%7C%20DNS-5E5E5E?style=flat)
![Virtualization](https://img.shields.io/badge/Virtualization-VMware-607078?style=flat&logo=vmware&logoColor=white)
![Forest](https://img.shields.io/badge/Forest-Single%20Forest-9C27B0?style=flat)
![OUs](https://img.shields.io/badge/OUs-5-FFB900?style=flat)
![Users](https://img.shields.io/badge/Users-25-4CAF50?style=flat)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=flat)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat)
![Demo Video](https://img.shields.io/badge/Demo%20Video-YouTube-FF0000?style=flat&logo=youtube&logoColor=white)
  

## 📖 Descripción General

Laboratorio práctico enfocado en la administración y seguridad de infraestructura Windows, desarrollado durante mi formación en Seguridad Informática.

El entorno está basado en **Windows Server 2025** y equipos cliente Windows unidos a un dominio. A lo largo del laboratorio se trabajan diferentes componentes de una infraestructura empresarial, desde la implementación de Active Directory hasta la aplicación de políticas de seguridad, gestión de actualizaciones, infraestructura de clave pública, evaluación de vulnerabilidades y administración de cuentas privilegiadas.

Este repositorio documenta las prácticas realizadas, incluyendo configuraciones, procedimientos, evidencias y resultados.

> **Plataforma principal:** Windows Server 2025
> **Virtualización:** VMware Workstation / VirtualBox

## Prácticas

| #  | Práctica                                                                          | Temas principales                                                 |
| -- | --------------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| 01 | [Active Directory](./01-active-directory/)                                        | AD DS, DNS, OUs, usuarios, dominio                                |
| 02 | [Directivas de Grupo](./02-group-policy/)                                         | GPO, restricciones, auditoría, sincronización de hora             |
| 03 | [WSUS](./03-wsus/)                                                                | Gestión de actualizaciones, GPO, equipos cliente                  |
| 04 | [PKI y Acceso Remoto Seguro](./04-pki-and-secure-remote-access/)                  | CA, certificados, autenticación SSH mediante clave pública        |
| 05 | [Evaluación de Vulnerabilidades](./05-vulnerability-assessment/)                  | Nessus, análisis de vulnerabilidades, gestión de riesgos          |
| 06 | [Remediación de Vulnerabilidades](./06-vulnerability-remediation/)                | Remediación, validación, comparación de resultados                |
| 07 | [Microsoft LAPS](./07-laps/)                                                      | Contraseñas de administrador local, expiración, control de acceso |
| 08 | [Administración de Administradores Locales](./08-local-administrator-management/) | Cuentas locales, grupos de dominio, privilegios administrativos   |

## Entorno

El entorno principal del laboratorio está compuesto por un controlador de dominio basado en Windows Server 2025 y equipos cliente Windows.

```text
                         Windows Server 2025
                       ┌─────────────────────┐
                       │ Active Directory    │
                       │ DNS                 │
                       │ Directivas de Grupo │
                       │ WSUS                │
                       │ PKI / CA            │
                       └──────────┬──────────┘
                                  │
                           Entorno de dominio
                                  │
                    ┌─────────────┴─────────────┐
                    │                           │
             Windows Cliente 01         Windows Cliente 02
                    │                           │
                    └─────────────┬─────────────┘
                                  │
                         Evaluaciones de seguridad
                                  │
                                Nessus
```

La cantidad de máquinas virtuales y su configuración puede variar dependiendo de la práctica.

## Principales temas

Durante el desarrollo de este laboratorio se trabajan los siguientes temas:

* Active Directory Domain Services
* DNS
* Unidades Organizativas y administración de grupos
* Directivas de Grupo
* Auditoría de Windows
* WSUS y gestión de actualizaciones
* Infraestructura de Clave Pública (PKI)
* Servicios de Certificados
* Autenticación SSH mediante clave pública
* Evaluación de vulnerabilidades
* Remediación de vulnerabilidades
* Microsoft LAPS
* Administración de cuentas administrativas locales
* Control de acceso
* Principio de mínimo privilegio

## Estructura del repositorio

```text
windows-server-security-lab/
│
├── README.md
├── README-EN.md
│
├── 01-active-directory/
│   └── README.md
│
├── 02-group-policy/
│   └── README.md
│
├── 03-wsus/
│   └── README.md
│
├── 04-pki-and-secure-remote-access/
│   └── README.md
│
├── 05-vulnerability-assessment/
│   └── README.md
│
├── 06-vulnerability-remediation/
│   └── README.md
│
├── 07-laps/
│   └── README.md
│
└── 08-local-administrator-management/
    └── README.md
```

Cada directorio contiene la documentación y las evidencias correspondientes a su respectiva práctica.

## Documentación

Dependiendo de la práctica, cada directorio puede incluir:

* Procedimientos de configuración
* Comandos de PowerShell
* Capturas de pantalla
* Diagramas de infraestructura o red
* Pasos de validación
* Resultados obtenidos
* Lecciones aprendidas
* Demostración en video

El objetivo es documentar no solamente cómo se realizó una configuración, sino también cómo se comprobó su funcionamiento.

## Notas

Las instrucciones académicas originales de algunas prácticas hacían referencia a **Windows Server 2016**. Sin embargo, todas las implementaciones documentadas en este repositorio fueron realizadas utilizando **Windows Server 2025**.

Algunas prácticas, especialmente las relacionadas con PKI y evaluación de vulnerabilidades, utilizan sistemas Linux o herramientas de seguridad adicionales como parte del entorno.

## Estado

En desarrollo.

El repositorio continuará incorporando nuevas prácticas, configuraciones y documentación a medida que evolucione el laboratorio.

---

#### 👨‍💻 Autor

**Fred Castillo**  
*Estudiante de Tecnólogo en Seguridad Informática*  
*Aspirante a Red Team | Seguridad Ofensiva*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Fred%20Castillo-0077B5?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/fredcastillo11/)
[![GitHub](https://img.shields.io/badge/GitHub-fredcastillo-100000?style=for-the-badge&logo=github)](https://github.com/fredcastillo)

---

