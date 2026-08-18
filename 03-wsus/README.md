# Instalación y configuración de WSUS

Implementación de **Windows Server Update Services (WSUS)** en un entorno de dominio basado en **Windows Server 2025**, como parte del laboratorio de Seguridad de Sistemas Operativos.

El objetivo de esta práctica es centralizar la administración de actualizaciones de Windows para los equipos del dominio, utilizando **WSUS + Group Policy** para controlar desde dónde se obtienen las actualizaciones, cuándo se instalan y cómo se notifica al administrador.

## Objetivo

* Instalar el rol **Windows Server Update Services (WSUS)**.
* Configurar WSUS en el Domain Controller.
* Crear y aplicar las GPO necesarias para los equipos del dominio.
* Configurar la descarga automática de actualizaciones.
* Establecer la instalación de actualizaciones para las **2:00 AM**.
* Configurar la notificación al administrador antes de la instalación.
* Configurar los equipos cliente y servidores para utilizar WSUS.
* Probar la distribución de actualizaciones desde el servidor hacia los equipos administrados.

## Entorno

| Componente                     | Configuración                  |
| ------------------------------ | ------------------------------ |
| Sistema operativo del servidor | Windows Server 2025            |
| Domain Controller              | `192.168.100.147`              |
| Dominio                        | `fred.castillo`                |
| Servicio                       | Windows Server Update Services |
| Clientes                       | Equipos Windows del dominio    |
| Administración                 | Group Policy                   |
| Virtualización                 | VMware Workstation             |

El laboratorio utiliza la infraestructura de Active Directory creada en los módulos anteriores.

## Arquitectura

```text
                         Windows Server 2025
                              DC01
                        192.168.100.147
                              │
                     ┌────────┴────────┐
                     │                 │
              Active Directory        WSUS
                     │                 │
                     └────────┬────────┘
                              │
                         Group Policy
                              │
               ┌──────────────┼──────────────┐
               │              │              │
               ▼              ▼              ▼
        Windows Client 01  Client 02   Windows Server
               │              │              │
               └──────────────┴──────────────┘
                         Windows Updates
```

## 1. Instalación del rol WSUS

La instalación comienza desde **Server Manager**.

Se selecciona:

```text
Manage
└── Add Roles and Features
```

Se utiliza una instalación basada en roles o características y se selecciona:

```text
Windows Server Update Services
```

Durante el asistente se instalan los componentes necesarios para administrar el servicio.

La instalación de WSUS requiere además seleccionar los servicios y componentes asociados al almacenamiento y administración de las actualizaciones.

## 2. Configuración inicial de WSUS

Después de instalar el rol, se inicia la configuración inicial de WSUS.

Durante esta fase se configuran los parámetros necesarios para que el servidor pueda sincronizar y administrar las actualizaciones disponibles.

Entre los elementos principales se encuentran:

* Fuente de sincronización.
* Idiomas de las actualizaciones.
* Productos.
* Clasificaciones.
* Programación de sincronización.
* Ubicación de almacenamiento de las actualizaciones.

La configuración utilizada debe mantenerse acorde con el entorno del laboratorio para evitar descargar productos o clasificaciones que no sean necesarios.

## 3. Configuración de las actualizaciones

WSUS permite centralizar la selección y distribución de actualizaciones hacia los equipos administrados.

El flujo utilizado en el laboratorio es:

```text
Microsoft Update
       ↓
      WSUS
       ↓
Aprobación / administración
       ↓
Equipos del dominio
```

De esta forma, los equipos cliente dejan de depender directamente de una configuración independiente de Windows Update y pasan a utilizar el servicio centralizado.

## 4. Configuración mediante Group Policy

Para que los equipos del dominio utilicen WSUS, se configuran las políticas correspondientes mediante **Group Policy Management**.

La configuración se realiza desde:

```text
Computer Configuration
└── Policies
    └── Administrative Templates
        └── Windows Components
            └── Windows Update
```

Las políticas se configuran para indicar a los equipos administrados la ubicación del servidor WSUS.

La dirección utilizada dependerá del protocolo y puerto configurados en el servidor. Como ejemplo:

```text
http://192.168.100.147
```

> La URL y el puerto exactos deben coincidir con la configuración real del servicio WSUS utilizado en el laboratorio.

## 5. Configuración del horario de instalación

Una de las condiciones de la práctica es establecer la instalación automática de actualizaciones a las:

```text
02:00 AM
```

La GPO correspondiente se configura para establecer el comportamiento de instalación automática y el horario definido para el laboratorio.

## 6. Descarga automática y notificación

También se configura una política para que:

1. Las actualizaciones se descarguen automáticamente.
2. El sistema notifique al administrador.
3. La instalación se realice de acuerdo con la política establecida.

Esto permite separar la etapa de **descarga** de la etapa de **instalación** y mantener un mayor control sobre el proceso de actualización.

## 7. Aplicación de las políticas

Después de configurar las GPO, los equipos cliente deben actualizar sus políticas.

En el equipo correspondiente se puede utilizar:

```powershell
gpupdate /force
```

Después se puede comprobar la aplicación de las políticas mediante:

```powershell
gpresult /r
```

o mediante un informe más detallado:

```powershell
gpresult /h gpresult.html
```

## 8. Registro del cliente en WSUS

Una vez aplicada la configuración, los equipos cliente deben comenzar a comunicarse con el servidor WSUS.

La validación debe realizarse tanto desde el cliente como desde la consola de administración de WSUS.

Desde el servidor se comprueba que los equipos administrados aparecen dentro de la consola de WSUS y comienzan a reportar su estado.

## 9. Prueba de actualizaciones

Como parte de la práctica se realiza una prueba de distribución de actualizaciones.

El flujo esperado es:

```text
WSUS
 ↓
Detectar actualización
 ↓
Aprobar / administrar actualización
 ↓
Cliente recibe la política
 ↓
Cliente detecta actualización
 ↓
Descarga
 ↓
Instalación según política
```

La prueba debe permitir comprobar que las actualizaciones pueden ser administradas desde el servidor y entregadas a los equipos del dominio.

## 10. Validación

La implementación se considera correcta después de comprobar:

* WSUS instalado correctamente.
* Servidor WSUS configurado.
* GPO de Windows Update aplicada.
* Equipos cliente configurados para utilizar WSUS.
* Clientes visibles desde la consola de WSUS.
* Descarga de actualizaciones según la política.
* Horario de instalación establecido para las 2:00 AM.
* Notificación al administrador configurada.
* Distribución de una actualización a los equipos de prueba.

## Comandos útiles para la validación

En los clientes:

```powershell
gpupdate /force
```

```powershell
gpresult /r
```

Para revisar información relacionada con el servicio de Windows Update:

```powershell
Get-Service wuauserv
```

También puede utilizarse `rsop.msc` para revisar de forma gráfica las políticas resultantes aplicadas al equipo.

## Evidencia

Las capturas de esta práctica se almacenan en:

```text
screenshots/
```

La evidencia debe mostrar tanto la configuración del servidor como la aplicación y validación desde los equipos cliente.

## Video

**Demostración de la práctica:**
[Ver video en YouTube](https://www.youtube.com/watch?v=QQKFb57v7rY)

## Resultado

Al finalizar la práctica, el entorno dispone de un servicio centralizado para la administración de actualizaciones de Windows.

La combinación de **WSUS + Group Policy + Active Directory** permite controlar desde un punto central el origen de las actualizaciones y establecer políticas comunes para los equipos del dominio.

## Lo aprendido

Esta práctica permitió trabajar con **Patch Management** en un entorno Windows empresarial y comprender la relación entre WSUS, Active Directory y Group Policy.

Además de instalar el servicio, se trabajó con la configuración centralizada de los clientes, la programación de instalaciones y la validación de la comunicación entre el servidor y los equipos administrados.

---

#### Autor

**Fred Castillo**
*Estudiante de Tecnólogo en Seguridad Informática*
*Aspirante a Red Team | Seguridad Ofensiva*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Fred%20Castillo-0077B5?style=for-the-badge\&logo=linkedin)](https://www.linkedin.com/in/fredcastillo11/)
[![GitHub](https://img.shields.io/badge/GitHub-fredcastillo-100000?style=for-the-badge\&logo=github)](https://github.com/fredcastillo)

---
