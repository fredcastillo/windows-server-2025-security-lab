🇪🇸 **Español** | 🇬🇧 [English](README-EN.md)

# Instalación y Configuración de WSUS

Implementación de **Windows Server Update Services (WSUS)** en Windows Server 2025 para centralizar la administración y distribución de actualizaciones dentro de un entorno de dominio.

Esta práctica forma parte del laboratorio de Seguridad de Sistemas Operativos y utiliza el dominio `fred.castillo` configurado en los módulos anteriores.

El objetivo es establecer un servidor WSUS, configurar los equipos del dominio para utilizarlo mediante **Group Policy** y definir diferentes comportamientos de actualización para equipos cliente y servidores.

## Objetivo

* Instalar el rol **Windows Server Update Services (WSUS)**.
* Configurar WSUS como servidor de actualizaciones del entorno.
* Seleccionar los productos y clasificaciones que serán sincronizados.
* Configurar GPOs para dirigir los equipos del dominio hacia el servidor WSUS.
* Configurar las PCs cliente para descargar e instalar actualizaciones automáticamente a las 2:00 AM.
* Configurar los servidores para descargar actualizaciones y notificar al administrador antes de su instalación.
* Aprobar una actualización desde WSUS.
* Verificar que el equipo cliente recibe la actualización aprobada.

## Entorno

| Componente               | Configuración                                         |
| ------------------------ | ----------------------------------------------------- |
| Sistema operativo        | Windows Server 2025                                   |
| Domain Controller / WSUS | `192.168.100.147`                                     |
| Dominio                  | `fred.castillo`                                       |
| Servicio                 | Windows Server Update Services                        |
| Clientes                 | Windows 10/11                                         |
| Virtualización           | VMware Workstation                                    |
| Administración           | Server Manager, WSUS Console, Group Policy Management |

## Arquitectura

El servidor Windows Server 2025 funciona como controlador de dominio y servidor WSUS dentro del laboratorio.

```text
                         Windows Server 2025
                         DC01 / WSUS Server
                           192.168.100.147
                                  │
                    ┌─────────────┴─────────────┐
                    │                           │
              GPO - Clientes              GPO - Servidores
                    │                           │
                    ▼                           ▼
             Windows Client                Windows Server
                    │                           │
                    └─────────────┬─────────────┘
                                  │
                           Windows Update
                                  │
                                  ▼
                               WSUS
                                  │
                           Microsoft Update
```

Las políticas permiten aplicar diferentes comportamientos de actualización dependiendo del tipo de equipo.

---

# 1. Instalación del rol WSUS

La instalación comienza desde **Server Manager**.

Se selecciona:

```text
Manage
└── Add Roles and Features
```

En la lista de roles se selecciona:

```text
Windows Server Update Services
```

Se completan los componentes requeridos por WSUS y se continúa con la instalación.

Después de finalizar la instalación inicial, Server Manager muestra las tareas de configuración posteriores al despliegue.

---

# 2. Configuración posterior a la instalación

Una vez instalado el rol, se ejecutan las tareas de **Post-Deployment Configuration** requeridas por WSUS.

El servidor debe reiniciarse para completar correctamente la instalación.

Después del reinicio se puede abrir la consola:

```text
Server Manager
└── Tools
    └── Windows Server Update Services
```

---

# 3. Configuración inicial de WSUS

Al abrir la consola de WSUS por primera vez se ejecuta el asistente de configuración.

El servidor se configura como el **servidor principal de actualizaciones** del laboratorio y obtiene las actualizaciones directamente desde **Microsoft Update**.

## Fuente de sincronización

```text
Microsoft Update
        │
        ▼
      WSUS
        │
        ▼
Equipos del dominio
```

Esto permite centralizar la administración de las actualizaciones antes de distribuirlas a los equipos del entorno.

---

# 4. Productos y clasificaciones

Para reducir la cantidad de contenido sincronizado, se seleccionan únicamente los productos y tipos de actualización necesarios para el laboratorio.

## Productos

Se desmarcan los productos que no son necesarios y se seleccionan:

* **Windows 10, version 1903 and later**
* **Windows Server, version 1903 and later**

La versión del sistema utilizada en el entorno se comprueba mediante:

```cmd
winver
```

## Clasificaciones

Para esta práctica se seleccionan:

* **Critical Updates**
* **Security Updates**

Esto permite centrar la sincronización en actualizaciones relacionadas con correcciones críticas y seguridad.

---

# 5. Organización de los equipos

Para administrar diferentes comportamientos de actualización, el laboratorio separa los equipos cliente y los servidores en diferentes ámbitos de administración.

La estructura conceptual es:

```text
fred.castillo
│
├── Computers / Clientes
│      └── Windows Client
│
└── Servers
       └── Windows Server
```

Esta separación permite aplicar políticas WSUS diferentes dependiendo del sistema que se esté administrando.

---

# 6. GPO para equipos cliente

Se crea o configura una GPO específica para las PCs cliente.

La política tiene como objetivo dirigir los equipos hacia el servidor WSUS local.

## Configuración principal

Se establece:

* Dirección del servidor WSUS local.
* Frecuencia de detección de actualizaciones: **1 hora**.
* Descarga automática de actualizaciones.
* Instalación programada para las **2:00 AM**.

El comportamiento esperado es:

```text
Cliente
   │
   ├── Consulta WSUS cada hora
   │
   ├── Descarga automáticamente
   │
   └── Instala a las 2:00 AM
```

La ruta del servicio de actualización apunta al servidor WSUS del laboratorio.

---

# 7. GPO para servidores

Los servidores utilizan una política diferente para evitar instalaciones automáticas que puedan provocar reinicios inesperados.

La configuración utilizada corresponde al comportamiento:

**Descargar automáticamente y notificar al administrador para la instalación.**

El flujo esperado es:

```text
Servidor
   │
   ├── Detecta actualización
   │
   ├── Descarga actualización
   │
   └── Notifica al administrador
             │
             └── Instalación manual
```

Esta separación permite aplicar una política más controlada a los servidores que a los equipos cliente.

---

# 8. Aplicación de las políticas

Una vez configuradas las GPOs, se fuerza su actualización mediante:

```cmd
gpupdate /force
```

El comando se utiliza para acelerar la aplicación de las nuevas configuraciones en los equipos del laboratorio.

Para verificar las políticas aplicadas también puede utilizarse:

```cmd
gpresult /r
```

Esto permite comprobar si las GPOs correspondientes al equipo están siendo aplicadas correctamente.

---

# 9. Aprobación de una actualización desde WSUS

Para comprobar el funcionamiento completo del entorno, se realiza una prueba utilizando una actualización disponible en WSUS.

Desde la consola:

```text
WSUS
└── All Updates
```

Se selecciona una actualización disponible, en este caso:

**Servicing Stack Update for Windows 10**

Posteriormente:

```text
Right Click
└── Approve
```

La actualización se aprueba para el grupo de equipos utilizado durante la prueba.

En el laboratorio se utiliza:

```text
Unassigned Computers
```

como grupo de prueba.

El flujo queda:

```text
Microsoft Update
       │
       ▼
      WSUS
       │
       │ Update available
       ▼
  Administrator
       │
       │ Approve
       ▼
Computer Group
       │
       ▼
Windows Client
```

---

# 10. Validación desde el equipo cliente

Después de aplicar las políticas y aprobar la actualización, se realiza la comprobación desde el equipo cliente.

Se abre:

```text
Settings
└── Windows Update
```

El sistema muestra el mensaje indicando que:

> La organización administra algunos valores de configuración.

Este mensaje sirve como indicio de que determinadas configuraciones están siendo administradas mediante políticas.

Posteriormente se selecciona:

**Buscar actualizaciones**

El cliente detecta la actualización previamente aprobada desde WSUS y comienza el proceso de descarga.

La actualización utilizada durante la demostración es:

**Servicing Stack Update for Windows 10**

Esto permite comprobar el flujo completo:

```text
WSUS
  ↓
Aprobación
  ↓
GPO
  ↓
Cliente
  ↓
Detección
  ↓
Descarga
```

---

# 11. Resultado

Al finalizar la práctica se dispone de un sistema centralizado de administración de actualizaciones.

```text
                        Microsoft Update
                               │
                               ▼
                         Windows Server
                              WSUS
                               │
                    ┌──────────┴──────────┐
                    │                     │
               GPO Clientes         GPO Servidores
                    │                     │
                    ▼                     ▼
              Windows Client        Windows Server
                    │                     │
              Instalar 2:00 AM      Descargar +
                                    Notificar
```

La prueba de aprobación de una actualización demuestra que el cliente puede recibir contenido administrado por WSUS en lugar de depender únicamente de una administración local de Windows Update.

---

# Validación

| Elemento          | Validación                                |
| ----------------- | ----------------------------------------- |
| WSUS              | Consola instalada y configurada           |
| Productos         | Windows 10 y Windows Server seleccionados |
| Clasificaciones   | Critical Updates y Security Updates       |
| GPO de clientes   | Servidor WSUS + instalación programada    |
| GPO de servidores | Descarga y notificación                   |
| Aplicación de GPO | `gpupdate /force` / `gpresult /r`         |
| Actualización     | Aprobada desde WSUS                       |
| Cliente           | Actualización detectada y descargada      |

---

# Evidencia

Las capturas de esta práctica se almacenan en:

```text
screenshots/
```

La evidencia incluye:

* Instalación del rol WSUS.
* Configuración inicial.
* Productos y clasificaciones.
* Configuración de GPOs.
* Aprobación de actualizaciones.
* Validación desde el equipo cliente.

## Video

**Demostración de la práctica:**
[Ver video en YouTube](https://www.youtube.com/watch?v=QQKFb57v7rY)

---

## Lo aprendido

Esta práctica permitió trabajar con **WSUS como mecanismo centralizado de administración de actualizaciones** dentro de un dominio Windows.

Se trabajó con la instalación y configuración del servicio, selección de productos y clasificaciones, integración con Group Policy y diferenciación del comportamiento de actualización entre clientes y servidores.

También se comprobó el flujo completo de una actualización:

```text
Sincronización
      ↓
Selección
      ↓
Aprobación
      ↓
Aplicación de GPO
      ↓
Detección por el cliente
      ↓
Descarga
      ↓
Instalación
```

---

## 👨‍💻 Autor

**Fred Castillo**  
**Estudiante de tecnologo en Seguridad Informática**  

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Fred%20Castillo-0077B5?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/fredcastillo11/)
[![GitHub](https://img.shields.io/badge/GitHub-fredcastillo-100000?style=for-the-badge&logo=github)](https://github.com/fredcastillo)

---
