🇪🇸 **Español** | 🇬🇧 [English](README-EN.md)

# Active Directory Domain Services

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

## Descripcion

Implementación de un entorno de dominio utilizando **Windows Server 2025**, como parte del laboratorio de Seguridad de Sistemas Operativos.

En esta práctica se configura desde cero un **Domain Controller** con los servicios de **Active Directory Domain Services (AD DS)** y **DNS**, y posteriormente se crea una estructura organizativa con cinco Unidades Organizativas (OUs), cada una con cinco usuarios.

## Objetivo

* Instalar Active Directory Domain Services.
* Instalar y configurar DNS.
* Promover Windows Server 2025 como Domain Controller.
* Crear un nuevo bosque y dominio.
* Crear cinco Unidades Organizativas.
* Crear cinco usuarios dentro de cada OU.
* Verificar el funcionamiento de los servicios y la estructura del dominio.

## Entorno

| Componente             | Configuración                                |
| ---------------------- | -------------------------------------------- |
| Sistema operativo      | Windows Server 2025                          |
| Roles                  | Active Directory Domain Services, DNS Server |
| Tipo de servidor       | Domain Controller                            |
| Virtualización         | VMware Workstation                           |
| Usuarios               | 25                                           |
| Unidades Organizativas | 5                                            |
| Dirección IP           | `192.168.100.147`                            |
| Máscara de red         | `255.255.255.0`                              |
| Puerta de enlace       | `192.168.100.1`                              |
| Dominio                | `fred.castillo`                              |

## Estructura del laboratorio

La estructura final del dominio está organizada de la siguiente manera:

```text
Dominio
│
├── Dirección de Tecnología
│   ├── Usuario 01
│   ├── Usuario 02
│   ├── Usuario 03
│   ├── Usuario 04
│   └── Usuario 05
│
├── Dirección Administrativa
│   ├── Usuario 01
│   ├── Usuario 02
│   ├── Usuario 03
│   ├── Usuario 04
│   └── Usuario 05
│
├── Dirección Legal
│   ├── Usuario 01
│   ├── Usuario 02
│   ├── Usuario 03
│   ├── Usuario 04
│   └── Usuario 05
│
├── Dirección de Comunicaciones
│   ├── Usuario 01
│   ├── Usuario 02
│   ├── Usuario 03
│   ├── Usuario 04
│   └── Usuario 05
│
└── Dirección de Gestión Humana
    ├── Usuario 01
    ├── Usuario 02
    ├── Usuario 03
    ├── Usuario 04
    └── Usuario 05
```

La práctica finaliza con **5 OUs y 25 cuentas de usuario** distribuidas dentro de ellas.

---

## 1. Instalación de Active Directory Domain Services

La instalación comienza desde **Server Manager**.

Se selecciona:

```text
Manage
└── Add Roles and Features
```

Se utiliza una instalación basada en roles o características y se selecciona:

```text
Active Directory Domain Services
```

Durante el proceso también se instala el componente correspondiente a **DNS Server**.

Una vez completada la instalación, Server Manager muestra la notificación correspondiente para continuar con la promoción del servidor.

---

## 2. Promoción del servidor a Domain Controller

Después de instalar AD DS, se selecciona:

```text
Promote this server to a domain controller
```

Como se trata del primer controlador de dominio del laboratorio, se selecciona:

```text
Add a new forest
```

Se establece como nombre del dominio el nombre definido para la práctica, basado en el primer nombre y apellido del estudiante.

También se configura la contraseña correspondiente al:

**Directory Services Restore Mode (DSRM)**

Esta contraseña se utilizaría para operaciones de recuperación del servicio de directorio.

---

## 3. Resolución de un problema de conectividad

Durante la promoción del servidor se presentó un problema relacionado con la configuración de red de la máquina virtual.

La causa identificada fue que el **adaptador de red estaba apagado/desconectado**.

### Solución

1. Se detiene temporalmente el procedimiento de promoción.
2. Se revisa la configuración de red de la máquina virtual.
3. Se habilita el adaptador de red.
4. Se retoma el procedimiento.
5. Se completa la promoción del servidor.
6. Se reinicia el servidor.

Este incidente permitió comprobar la importancia de validar la conectividad de red antes de realizar configuraciones dependientes de servicios como Active Directory y DNS.

---

## 4. Verificación del Domain Controller

Después del reinicio se verifica nuevamente el estado del servidor desde **Server Manager**.

Se comprueba que:

* El nombre del dominio aparece correctamente.
* Active Directory Domain Services se encuentra instalado.
* DNS se encuentra disponible.
* El servidor funciona como controlador de dominio.

A partir de este punto, el servidor queda preparado para comenzar la configuración de la estructura organizativa.

---

## 5. Creación de las Unidades Organizativas

Para administrar los usuarios de forma organizada se utiliza:

```text
Active Directory Users and Computers
```

Desde el dominio se selecciona la opción para crear una nueva:

```text
Organizational Unit
```

Se crean las siguientes OUs:

```text
Dirección de Tecnología
Dirección Administrativa
Dirección Legal
Dirección de Comunicaciones
Dirección de Gestión Humana
```

Las OUs permiten organizar las cuentas y posteriormente facilitar la aplicación de políticas de grupo de acuerdo con las necesidades de cada área.

---

## 6. Creación de usuarios

Dentro de cada OU se crean las cuentas correspondientes.

El proceso se realiza desde:

```text
Active Directory Users and Computers
└── Organizational Unit
    └── New
        └── User
```

Durante la creación de una de las cuentas se presentó un problema relacionado con la contraseña.

### Política de complejidad

Windows Server rechazó inicialmente la contraseña utilizada debido a los requisitos de complejidad configurados en el entorno.

La contraseña fue modificada para cumplir con los requisitos establecidos por la política de seguridad.

Esto permitió comprobar directamente cómo las políticas de contraseñas del dominio afectan la creación de nuevas cuentas.

---

## 7. Resultado

Al finalizar la práctica se obtiene un entorno de dominio funcional con:

* 1 Domain Controller.
* Active Directory Domain Services instalado.
* DNS configurado.
* 1 bosque y dominio.
* 5 Unidades Organizativas.
* 25 cuentas de usuario.
* 5 usuarios por cada OU.

La estructura queda preparada para utilizarse en las siguientes prácticas del laboratorio.

---

## Validación

La implementación se considera correcta después de comprobar:

* Acceso a **Active Directory Users and Computers**.
* Existencia del dominio.
* Existencia de las cinco OUs.
* Existencia de cinco usuarios dentro de cada OU.
* Funcionamiento de los servicios de AD DS y DNS.
* Inicio correcto del servidor después de la promoción.

---

## Evidencia

Las evidencias de la implementación se encuentran en el directorio:

```text
screenshots/
```

La práctica también cuenta con una demostración en video donde se muestra el proceso de instalación, configuración y creación de la estructura del dominio.

**Video de la práctica:**
[Ver demostración en YouTube](https://www.youtube.com/watch?v=H8pR4lc_Jws)

## Lo aprendido

Esta práctica permitió trabajar los fundamentos necesarios para construir una infraestructura basada en Active Directory.

Además de la instalación de los roles, se trabajó con la creación de dominios, organización mediante OUs y administración de usuarios. También se presentaron situaciones reales de troubleshooting durante la implementación, como la pérdida de conectividad de la máquina virtual y el cumplimiento de las políticas de complejidad de contraseñas.

Este entorno sirve como base para las siguientes prácticas del laboratorio, especialmente **Group Policy, WSUS, PKI, LAPS y administración de privilegios**.

---

#### 👨‍💻 Autor

**Fred Castillo**  
*Estudiante de Tecnólogo en Seguridad Informática*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Fred%20Castillo-0077B5?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/fredcastillo11/)
[![GitHub](https://img.shields.io/badge/GitHub-fredcastillo-100000?style=for-the-badge&logo=github)](https://github.com/fredcastillo)

---

