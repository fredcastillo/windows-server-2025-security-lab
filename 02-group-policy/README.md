🇪🇸 **Español** | 🇬🇧 [English](README-EN.md)

<h1 align="center">Aplicación de Directivas de Grupo (GPO)</h1>

<p align="center">
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Windows%20Server-2025-0078D6?style=for-the-badge&logo=windows&logoColor=white" alt="Windows Server"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Rol-Controlador%20de%20Dominio-2D72D9?style=for-the-badge" alt="Controlador de Dominio"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Tecnología-GPO-5E5E5E?style=for-the-badge" alt="GPO"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Despliegue%20de%20Software-Chrome-4285F4?style=for-the-badge&logo=googlechrome&logoColor=white" alt="Despliegue de Chrome"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Restricciones-Panel%20de%20Control%20%7C%20CMD%20%7C%20Regedit-FF6F00?style=for-the-badge" alt="Restricciones"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Auditoría-Inicios%20de%20sesión%20%7C%20Procesos%20%7C%20Sistema-9C27B0?style=for-the-badge" alt="Políticas de Auditoría"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/NTP-Sincronización%20de%20Hora-4CAF50?style=for-the-badge" alt="NTP"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Estado-Completado-brightgreen?style=for-the-badge" alt="Estado"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab/blob/main/LICENSE"><img src="https://img.shields.io/badge/Licencia-MIT-yellow?style=for-the-badge" alt="Licencia"></a>
  <a href="https://www.youtube.com/watch?v=hRDxHtdWJE8"><img src="https://img.shields.io/badge/Video%20demostración-YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white" alt="Video demostración"></a>
</p>

## Descripcion

Implementación y aplicación de **Group Policy Objects (GPOs)** en un entorno de dominio basado en **Windows Server 2025**, como parte del laboratorio de Seguridad de Sistemas Operativos.

En esta práctica se utilizan Directivas de Grupo para automatizar la instalación de software, restringir determinadas herramientas administrativas, configurar la sincronización de hora y habilitar políticas de auditoría de seguridad en los equipos del dominio.

## Objetivo

Implementar y validar las siguientes políticas:

* Instalación automatizada de **Google Chrome** mediante GPO.
* Restricción del acceso al **Panel de Control**.
* Restricción del acceso a **CMD**.
* Restricción del acceso a **Regedit**.
* Configuración de sincronización de hora mediante el **Domain Controller**.
* Auditoría de inicios de sesión.
* Auditoría de eventos de seguridad.
* Auditoría relacionada con la creación y seguimiento de procesos.

## Entorno

| Componente                     | Configuración                   |
| ------------------------------ | ------------------------------- |
| Sistema operativo del servidor | Windows Server 2025             |
| Domain Controller              | `192.168.100.147`               |
| Dominio                        | `fred.castillo`                 |
| Cliente                        | Windows 10/11                   |
| Herramienta de administración  | Group Policy Management         |
| Virtualización                 | VMware Workstation              |
| Software distribuido           | Google Chrome Enterprise `.msi` |

## Escenario

La práctica parte del dominio configurado en el módulo anterior:

```text
fred.castillo
│
├── Active Directory
├── DNS
└── Group Policy
       │
       └── Windows Client
```

Las políticas se administran de forma centralizada desde el Domain Controller y posteriormente se validan desde el equipo cliente.

---

# 1. Instalación de Google Chrome mediante GPO

El primer objetivo consiste en automatizar la instalación de Google Chrome en los equipos del dominio.

## 1.1 Preparar el instalador

Se utiliza una versión **Google Chrome Standalone Enterprise** en formato `.msi`.

El instalador se coloca en una carpeta compartida del servidor para que los equipos cliente puedan acceder al paquete mediante la red.

La ruta utilizada para la implementación debe ser una **ruta UNC**, por ejemplo:

```text
\\DC01\Software\Chrome\GoogleChromeStandaloneEnterprise64.msi
```

> La ruta exacta puede variar dependiendo de la configuración del laboratorio.

## 1.2 Crear la GPO

Desde el Domain Controller se abre:

```text
Group Policy Management
```

Se crea una nueva GPO denominada:

```text
Chrome installer
```

La política se configura mediante:

```text
Computer Configuration
└── Policies
    └── Software Settings
        └── Software Installation
```

Se agrega el paquete `.msi` utilizando la ruta de red correspondiente.

El paquete se configura como:

```text
Assigned
```

De esta forma, la instalación queda controlada por la política aplicada al equipo.

## 1.3 Actualizar las políticas

Una vez vinculada la GPO al ámbito correspondiente, se actualizan las políticas utilizando:

```powershell
gpupdate /force
```

Después se reinicia o se vuelve a iniciar sesión en el equipo cliente para que Windows procese la instalación.

## 1.4 Validación

En el equipo cliente se comprueba que **Google Chrome aparece instalado automáticamente**, sin necesidad de ejecutar manualmente el instalador.

---

# 2. Restricción del Panel de Control, CMD y Regedit

La segunda parte de la práctica consiste en limitar el acceso de los usuarios a determinadas herramientas del sistema.

Para ello se crea una nueva GPO denominada:

```text
bloqueo administrativo cmd edit
```

## 2.1 Bloquear el Panel de Control

La configuración se realiza desde:

```text
User Configuration
└── Policies
    └── Administrative Templates
        └── Control Panel
```

Se habilita la política correspondiente para impedir el acceso al Panel de Control.

## 2.2 Bloquear CMD

La restricción del símbolo del sistema se configura desde:

```text
User Configuration
└── Policies
    └── Administrative Templates
        └── System
```

Se habilita la política para impedir el acceso al **Command Prompt**.

## 2.3 Bloquear Regedit

Desde la misma sección de políticas administrativas se configura la restricción para impedir el acceso a las herramientas de edición del Registro.

El objetivo es evitar que los usuarios puedan modificar directamente configuraciones sensibles del sistema.

## 2.4 Validación

En el equipo cliente se actualizan las políticas:

```powershell
gpupdate /force
```

Posteriormente se comprueba que el usuario no puede acceder a:

* Panel de Control.
* CMD.
* Regedit.

El sistema muestra un mensaje indicando que la acción ha sido restringida por el administrador.

---

# 3. Sincronización de hora mediante el Domain Controller

La tercera configuración utiliza una GPO denominada:

```text
NTP
```

El objetivo es que los equipos cliente utilicen el Domain Controller como referencia para la sincronización de tiempo.

La configuración se realiza desde:

```text
Computer Configuration
└── Policies
    └── Administrative Templates
        └── System
            └── Windows Time Service
                └── Time Providers
```

Se habilitan las políticas necesarias para configurar el servicio de tiempo de Windows en los clientes.

La sincronización de hora es especialmente importante en un entorno Active Directory porque Kerberos y otros mecanismos del dominio dependen de una correcta sincronización temporal.

---

# 4. Auditoría de seguridad

Para la última parte del laboratorio se crea una GPO denominada:

```text
auditorías de seguridad
```

La configuración se realiza desde:

```text
Computer Configuration
└── Policies
    └── Windows Settings
        └── Security Settings
            └── Local Policies
                └── Audit Policy
```

Se habilitan las auditorías correspondientes para registrar eventos relevantes de seguridad.

## 4.1 Auditoría de inicios de sesión

Se configura la auditoría de eventos de **Logon** para registrar tanto eventos exitosos como fallidos.

Esto permite identificar intentos de autenticación correctos e incorrectos.

## 4.2 Seguimiento de procesos

Se habilita la auditoría relacionada con **Process Tracking** para registrar eventos asociados con la creación y ejecución de procesos.

Esto puede utilizarse posteriormente como fuente de información para análisis de seguridad.

## 4.3 Eventos del sistema

También se habilitan políticas relacionadas con **System Events** para registrar determinados eventos generados por el sistema operativo.

---

# 5. Validación mediante Event Viewer

Para comprobar que las auditorías están funcionando se utiliza:

```text
Event Viewer
```

En el laboratorio se limpian previamente los registros de seguridad para facilitar la identificación de los nuevos eventos generados durante la prueba.

Posteriormente, desde el equipo cliente:

1. Se intenta iniciar sesión utilizando una contraseña incorrecta.
2. Se realiza un inicio de sesión correcto.
3. Se actualizan los registros de seguridad.
4. Se revisan los nuevos eventos registrados.

Esto permite comprobar que los intentos de autenticación generan eventos correspondientes en el registro de seguridad.

---

# 6. Validación de las GPO

Además de comprobar visualmente los resultados, las políticas pueden verificarse desde el cliente mediante:

```powershell
gpupdate /force
```

y:

```powershell
gpresult /r
```

`gpupdate` fuerza la actualización de las directivas, mientras que `gpresult` permite comprobar las políticas que han sido aplicadas al equipo o usuario.

---

# 7. Resultado

Al finalizar la práctica, el entorno cuenta con varias políticas centralizadas para administrar los equipos del dominio:

```text
Domain Controller
│
├── Chrome installer
│      └── Instalación automática de Chrome
│
├── bloqueo administrativo cmd edit
│      ├── Bloqueo de Panel de Control
│      ├── Bloqueo de CMD
│      └── Bloqueo de Regedit
│
├── NTP
│      └── Sincronización de hora
│
└── auditorías de seguridad
       ├── Logon
       ├── Process Tracking
       └── System Events
```

Las políticas fueron aplicadas y verificadas desde el equipo cliente, incluyendo la comprobación de restricciones y la generación de eventos de seguridad.

---

# Evidencia

Las capturas correspondientes a esta práctica se almacenan en:

```text
screenshots/
```

La evidencia incluye la configuración de las GPO, la aplicación de políticas y la validación desde el equipo cliente.

## Video

**Demostración de la práctica:**
[Ver video en YouTube](https://www.youtube.com/watch?v=hRDxHtdWJE8)

---

## Lo aprendido

Esta práctica permitió trabajar con **Group Policy** como mecanismo de administración centralizada de equipos Windows dentro de un dominio.

Además de la creación y vinculación de GPOs, se trabajó con distribución de software, restricciones de acceso, configuración del servicio de tiempo y auditoría de eventos de seguridad.

La práctica también permitió comprobar el ciclo completo de una política:

```text
Crear GPO
   ↓
Configurar política
   ↓
Vincular GPO
   ↓
Actualizar políticas
   ↓
Validar en cliente
   ↓
Comprobar resultados
```

---

## 👨‍💻 Autor

**Fred Castillo**  
**Estudiante de tecnologo en Seguridad Informática**  

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Fred%20Castillo-0077B5?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/fredcastillo11/)
[![GitHub](https://img.shields.io/badge/GitHub-fredcastillo-100000?style=for-the-badge&logo=github)](https://github.com/fredcastillo)

---
