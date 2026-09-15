# 06 — Troubleshooting: Explorer vs PowerShell

## Contexto

Durante la validación del File Server surgió un problema al intentar acceder desde la navegación normal de Windows Explorer al recurso:

```text
\\WIN-IORAFMP55C9\Administrativa
```

El usuario utilizado para la prueba era:

```text
FRED\AlanS12
```

y pertenecía al grupo:

```text
GG_Administrativa
```

El comportamiento era importante porque el recurso parecía estar correctamente configurado, pero la navegación normal mediante Explorer mostraba:

```text
No se permite el acceso al recurso
```

---

## Objetivo de la investigación

El objetivo fue determinar si el problema estaba relacionado con:

```text
Identidad
Kerberos
Red
SMB
Permisos del recurso compartido
Permisos NTFS
Políticas de seguridad
Explorer
```

En lugar de cambiar configuraciones sin evidencia, se decidió validar cada capa por separado.

---

## 1. Validación de identidad

Primero se confirmó la identidad del usuario:

```cmd
whoami
```

Resultado esperado:

```text
fred\alans12
```

También se verificó la pertenencia a grupos:

```cmd
whoami /groups
```

La pertenencia a:

```text
GG_Administrativa
```

fue confirmada.

---

## 2. Validación de Kerberos

Se utilizó:

```cmd
klist
```

para revisar los tickets Kerberos disponibles.

Se encontró un ticket válido para:

```text
cifs/WIN-IORAFMP55C9
```

Esto indicó que la autenticación Kerberos para el servicio SMB estaba funcionando.

---

## 3. Validación del recurso

Se comprobó directamente la ruta:

```text
\\WIN-IORAFMP55C9\Administrativa
```

mediante PowerShell:

```powershell
Test-Path "\\WIN-IORAFMP55C9\Administrativa"
```

El resultado fue:

```text
True
```

Esto indicó que la ruta era accesible desde PowerShell.

---

## 4. Validación de permisos del recurso

Se verificaron los permisos SMB mediante:

```powershell
Get-SmbShareAccess -Name "Administrativa"
```

La configuración relevante mostró:

```text
GG_Administrativa → Change
```

Esto coincidía con el modelo de permisos previsto para el departamento.

---

## 5. Validación de sesión SMB

Se utilizó:

```powershell
Get-SmbSession
```

para comprobar que existía una sesión SMB real.

La sesión utilizaba:

```text
Dialect: 3.1.1
```

También se revisaron archivos abiertos mediante:

```powershell
Get-SmbOpenFile
```

y se encontraron archivos asociados al usuario:

```text
AlanS12
```

Esto proporcionó evidencia adicional de que el acceso SMB estaba funcionando.

---

## 6. Validación de permisos NTFS

La ruta física correcta del recurso era:

```text
D:\Departamentos\Administrativa
```

Se verificó mediante:

```cmd
icacls "D:\Departamentos\Administrativa"
```

Durante la investigación también se había probado anteriormente:

```text
D:\Administrativa
```

pero esta ruta fue descartada por ser incorrecta.

La ruta válida era:

```text
D:\Departamentos\Administrativa
```

---

## 7. Validación de red

Se comprobó la conectividad con el puerto SMB:

```powershell
Test-NetConnection WIN-IORAFMP55C9 -Port 445
```

Resultado:

```text
TcpTestSucceeded : True
```

Esto confirmó que el puerto 445 estaba accesible.

---

## 8. Validación de políticas de inicio de sesión

También se revisó la política:

```text
SeDenyNetworkLogonRight
```

No se encontró evidencia de que esta restricción estuviera siendo aplicada al usuario.

Por tanto, esta política no explicaba el comportamiento observado.

---

## 9. Pruebas mediante PowerShell

Se realizaron varias operaciones directamente sobre el recurso:

```powershell
Test-Path
Get-ChildItem
New-Item
Set-Content
```

Las pruebas fueron exitosas.

Esto permitió demostrar que el usuario podía:

- Detectar el recurso
- Enumerar su contenido
- Crear archivos/directorios
- Escribir contenido

---

## 10. Prueba iniciando Explorer explícitamente

Una prueba especialmente importante fue:

```powershell
Start-Process explorer.exe "\\WIN-IORAFMP55C9\Administrativa"
```

Esta acción permitió abrir Explorer directamente con la ruta UNC y mostró el contenido real del recurso.

---

## Análisis

En este punto se tenían dos comportamientos:

### Navegación normal

```text
Explorer
   ↓
\\WIN-IORAFMP55C9\Administrativa
   ↓
No se permite el acceso al recurso
```

### Acceso mediante PowerShell / Explorer explícito

```text
PowerShell
   ↓
Test-Path → True
Get-ChildItem → Correcto
New-Item → Correcto
Set-Content → Correcto
Start-Process explorer.exe + UNC → Correcto
```

La conclusión defendible es que el problema quedó **aislado al método de acceso utilizado por la navegación normal de Explorer**.

No existe evidencia suficiente en esta investigación para afirmar una causa interna específica de Explorer, como un supuesto "bug de Explorer", caché de SMB, token de UAC o problema de doble salto.

---

## Resultado del troubleshooting

La investigación permitió descartar varias capas como causa principal:

```text
✓ Identidad
✓ Membresía de grupo
✓ Kerberos
✓ SMB
✓ Puerto 445
✓ Permisos del recurso
✓ Permisos NTFS
✓ Operaciones de lectura/escritura
```

El comportamiento restante correspondía al método de navegación normal de Explorer.

---

## Metodología utilizada

Este caso demostró la utilidad de un troubleshooting por capas:

```text
Identity
    ↓
Kerberos
    ↓
Network
    ↓
SMB
    ↓
Share Permissions
    ↓
NTFS
    ↓
Application Behavior
```

La ventaja de este enfoque fue evitar modificaciones innecesarias sobre componentes que ya estaban funcionando.

---

## Evidencia

```text
../../assets/06-troubleshooting/
```

Capturas sugeridas:

```text
01-explorer-error.png
02-whoami-groups.png
03-klist.png
04-test-path.png
05-smb-share-access.png
06-smb-session.png
07-smb-open-file.png
08-ntfs-permissions.png
09-port-445.png
10-powershell-file-access.png
11-explorer-explicit-path.png
12-final-analysis.png
```

---

## Resultado final

Este incidente permitió demostrar que:

```text
✓ La identidad era válida
✓ Kerberos funcionaba
✓ SMB funcionaba
✓ El puerto 445 estaba accesible
✓ Los permisos correspondientes estaban configurados
✓ PowerShell podía acceder al recurso
✓ Explorer podía abrirse explícitamente con la ruta UNC
```

Por lo tanto, el problema no fue tratado como una falla general del File Server, sino como un comportamiento específico del método de acceso normal de Explorer.