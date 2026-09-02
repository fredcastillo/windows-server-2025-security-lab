🇪🇸 **Español** | 🇬🇧 [English](README-EN.md)

<h1 align="center">Administración del Administrador Local con GPO</h1>

<p align="center">
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Windows%20Server-2025-0078D6?style=for-the-badge&logo=windows&logoColor=white" alt="Windows Server"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Tecnología-GPO-5E5E5E?style=for-the-badge" alt="GPO"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Cuenta%20renombrada-optimus-2D72D9?style=for-the-badge" alt="Renombrado a optimus"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Script%20de%20Inicio-PowerShell-4CAF50?style=for-the-badge&logo=powershell&logoColor=white" alt="Script PowerShell"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Grupo%20local-IT%20Support%20agregado-FF6F00?style=for-the-badge" alt="IT Support agregado"></a>
  <a href="https://github.com/fredcastillo/ADDS-Lab"><img src="https://img.shields.io/badge/Estado-Completado-brightgreen?style=for-the-badge" alt="Estado"></a>
</p>

## Objetivo

Implementar mediante **Group Policy** una configuración centralizada para administrar cuentas y privilegios de administrador local en equipos unidos al dominio.

La práctica aborda tres requisitos principales:

1. Renombrar la cuenta integrada de administrador local de `Administrator` a `optimus`.
2. Establecer la contraseña de la cuenta mediante un PowerShell Startup Script.
3. Agregar un grupo de usuarios del dominio al grupo local `Administrators`.

El objetivo es demostrar cómo una GPO puede utilizarse para aplicar una configuración uniforme sobre los equipos pertenecientes a una determinada OU.

---

## Entorno del laboratorio

| Componente                | Configuración                    |
| ------------------------- | -------------------------------- |
| Servidor                  | Windows Server 2025              |
| Servicio de directorio    | Active Directory Domain Services |
| Administración            | Group Policy                     |
| Cliente                   | Windows unido al dominio         |
| Cuenta local administrada | `optimus`                        |
| Grupo de dominio          | `FRED\IT SUPPORT`                |
| Grupo local objetivo      | `Administrators`                 |

---

## Diseño de la solución

La implementación utiliza tres mecanismos dentro de la GPO:

| Requisito                                 | Mecanismo                                         |
| ----------------------------------------- | ------------------------------------------------- |
| Renombrar Administrator                   | Security Options                                  |
| Cambiar contraseña                        | PowerShell Startup Script                         |
| Agregar grupo de dominio a Administrators | Group Policy Preferences - Local Users and Groups |

La contraseña del laboratorio se establece mediante un Startup Script. Para un entorno real, no se recomienda almacenar contraseñas fijas en scripts o directivas de grupo; una solución como Windows LAPS es más apropiada para administrar credenciales locales.

---

## Arquitectura

```text
                         Active Directory
                               │
                               ▼
                        OU de equipos
                               │
                               ▼
                  GPO - Configuración Local PCs
                               │
             ┌─────────────────┼──────────────────┐
             │                 │                  │
             ▼                 ▼                  ▼
       Rename Account     Startup Script     Local Users &
       Administrator       Set-Optimus.ps1      Groups
             │                 │                  │
             ▼                 ▼                  ▼
          optimus       Configura password    FRED\IT SUPPORT
                                                   │
                                                   ▼
                                          Local Administrators
```

---

# 1. Crear la GPO

En el controlador de dominio abre:

```text
Server Manager
└── Tools
    └── Group Policy Management
```

Localiza la OU donde se encuentran los equipos cliente y crea una nueva GPO vinculada a esa OU.

En el laboratorio se utiliza una GPO destinada a administrar la configuración local de los equipos.

![GPO linked to the target OU](screenshots/01-gpo-linked.png)

---

# 2. Renombrar la cuenta Administrator

La primera configuración modifica el nombre de la cuenta integrada de administrador local.

En el editor de la GPO navega hasta:

```text
Computer Configuration
└── Policies
    └── Windows Settings
        └── Security Settings
            └── Local Policies
                └── Security Options
```

Busca:

```text
Accounts: Rename administrator account
```

Habilita:

```text
Define this policy setting
```

y establece:

```text
optimus
```

como nuevo nombre.

![Rename Administrator account](screenshots/02-rename-administrator.png)

---

# 3. Crear el Startup Script

La contraseña de `optimus` se establece mediante un script de PowerShell ejecutado durante el inicio del equipo.

El script identifica la cuenta integrada de administrador mediante el SID terminado en:

```text
-500
```

Una versión sanitizada del script es:

```powershell
# Buscar la cuenta integrada de Administrador
$admin = Get-LocalUser |
    Where-Object { $_.SID.Value -match "-500$" }

if ($null -eq $admin) {
    throw "No se encontró la cuenta local integrada de Administrador."
}

# Renombrar la cuenta si es necesario
if ($admin.Name -ne "optimus") {
    Rename-LocalUser -Name $admin.Name -NewName "optimus"
}

# Establecer la contraseña
$securePassword = ConvertTo-SecureString "<LAB_PASSWORD>" -AsPlainText -Force
Set-LocalUser -Name "optimus" -Password $securePassword

# Habilitar la cuenta
Enable-LocalUser -Name "optimus"
```

El script utilizado en el laboratorio se guarda como:

```text
Set-Optimus.ps1
```

La contraseña real no debe incluirse en el repositorio.

---

# 4. Agregar el script como Startup Script

En el editor de la GPO navega hasta:

```text
Computer Configuration
└── Policies
    └── Windows Settings
        └── Scripts (Startup/Shutdown)
            └── Startup
                └── PowerShell Scripts
```

Agrega:

```text
Set-Optimus.ps1
```

como PowerShell Startup Script.

![Startup Script configuration](screenshots/03-startup-script.png)

El script se ejecutará durante el arranque del equipo cuando la configuración de la GPO sea procesada.

---

# 5. Agregar el grupo de dominio a Administrators

La siguiente configuración agrega un grupo de usuarios del dominio al grupo local de administradores.

En este laboratorio se utiliza:

```text
FRED\IT SUPPORT
```

En el editor de la GPO navega hasta:

```text
Computer Configuration
└── Preferences
    └── Control Panel Settings
        └── Local Users and Groups
```

Crea:

```text
New
└── Local Group
```

Configura:

```text
Action: Update
Group Name: Administrators
Member to add: FRED\IT SUPPORT
```

Se utiliza **Update** en lugar de **Replace** para agregar el grupo sin reemplazar los miembros existentes del grupo local.

![Local Group configuration](screenshots/04-local-group-policy.png)

---

# 6. Aplicar la GPO en el cliente

Comprueba que el equipo cliente se encuentre dentro de la OU donde se vinculó la GPO.

En el cliente abre PowerShell o CMD como administrador y ejecuta:

```powershell
gpupdate /force
```

Después reinicia el equipo:

```cmd
shutdown /r /t 0
```

El reinicio permite que la configuración de equipo y el Startup Script se procesen durante el arranque.

---

# 7. Verificar el cambio de nombre

Después del reinicio, abre PowerShell y ejecuta:

```powershell
Get-LocalUser
```

La salida debe mostrar:

```text
optimus
```

También puedes utilizar:

```text
lusrmgr.msc
```

y revisar:

```text
Local Users and Groups
└── Users
```

![Local administrator renamed to optimus](screenshots/05-optimus-validation.png)

Esto confirma que la cuenta integrada de administrador ahora utiliza el nombre `optimus`.

---

# 8. Verificar el acceso con optimus

Cierra la sesión administrativa del equipo y prueba iniciar sesión localmente utilizando:

```text
.\optimus
```

La contraseña utilizada corresponde a la configurada por el Startup Script.

No debe aparecer ninguna contraseña real en capturas ni en documentación pública.

---

# 9. Verificar el grupo de administradores locales

En el cliente ejecuta:

```powershell
Get-LocalGroupMember -Group "Administrators"
```

Dependiendo del idioma del sistema, el grupo puede aparecer como:

```text
Administrators
```

o:

```text
Administradores
```

En la lista debe aparecer:

```text
FRED\IT SUPPORT
```

como miembro del grupo local.

![Local Administrators membership](screenshots/06-local-admin-validation.png)

---

# 10. Verificar los privilegios administrativos

Inicia sesión con un usuario perteneciente al grupo de dominio y ejecuta:

```powershell
whoami
```

Después:

```cmd
net localgroup administrators
```

Esto permite comprobar la identidad utilizada y verificar la pertenencia del grupo de dominio al grupo local de administradores.

---

# Solución de problemas

### La cuenta sigue llamándose Administrator

Comprueba que el equipo esté en la OU correcta y ejecuta:

```powershell
gpresult /r
```

Verifica que la GPO esté aplicada y que ninguna otra directiva esté sobrescribiendo la configuración.

### optimus existe pero la contraseña no cambió

Comprueba que:

```text
Set-Optimus.ps1
```

esté configurado como PowerShell Startup Script.

Reinicia el cliente y revisa:

```text
Event Viewer
└── Applications and Services Logs
    └── Microsoft
        └── Windows
            └── GroupPolicy
                └── Operational
```

### El grupo de dominio no aparece en Administrators

Verifica el formato:

```text
DOMAIN\Group
```

En este laboratorio:

```text
FRED\IT SUPPORT
```

También comprueba que la configuración Local Users and Groups utilice:

```text
Action = Update
```

### Administrators aparece con otro nombre

Ejecuta:

```powershell
Get-LocalGroup
```

para conocer el nombre del grupo local en el idioma del sistema.

---

# Consideraciones de seguridad

Esta práctica demuestra:

* administración centralizada mediante Group Policy;
* renombrado de cuentas locales;
* ejecución de scripts de inicio;
* administración de grupos locales;
* asignación centralizada de privilegios administrativos.

Sin embargo, **una contraseña fija almacenada en un Startup Script no es un diseño apropiado para producción**.

Por esta razón:

* la contraseña real no se incluye en este repositorio;
* `<LAB_PASSWORD>` se utiliza como marcador;
* las capturas deben ocultar cualquier credencial;
* el documento original debe sanitizarse antes de publicarlo.

Para entornos reales, una solución dedicada como Windows LAPS resulta más adecuada para la administración de contraseñas locales.

---

# Resultado

La GPO permite aplicar una configuración centralizada a los equipos de la OU:

```text
Administrator
      ↓
   optimus

Startup Script
      ↓
Configuración de contraseña

FRED\IT SUPPORT
      ↓
Local Administrators
```

Con la política aplicada, el equipo cliente recibe el nuevo nombre de la cuenta integrada de administrador, ejecuta el Startup Script durante el arranque y agrega el grupo de dominio seleccionado al grupo local de administradores.

La práctica demuestra cómo Group Policy puede utilizarse para administrar cuentas locales y privilegios administrativos de forma centralizada.

---

## Documentación

Este módulo fue documentado mediante un **How-To técnico con capturas del laboratorio**, ya que no se realizó una demostración en video.

---

## 👨‍💻 Autor

**Fred Castillo**  
*Estudiante de Tecnólogo en Seguridad Informática*  

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Fred%20Castillo-0077B5?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/fredcastillo11/)
[![GitHub](https://img.shields.io/badge/GitHub-fredcastillo-100000?style=for-the-badge&logo=github)](https://github.com/fredcastillo)
