# 05 — Redirección de Carpetas y Sincronización de Tiempo

## Contexto

El proyecto requería centralizar los documentos de los usuarios y mantener la sincronización de tiempo dentro del dominio.

Para el almacenamiento de documentos se utilizó:

```text
\\WIN-IORAFMP55C9\Usuarios$
```

con almacenamiento físico en:

```text
D:\Usuarios
```

---

## Recurso Usuarios$

El recurso compartido `Usuarios$` fue configurado como un recurso SMB oculto.

Los permisos del recurso incluyeron:

```text
Domain Admins → Full Control
Authenticated Users → Change
```

Los permisos NTFS del directorio raíz fueron configurados para permitir la creación y administración de las carpetas de usuarios.

Se utilizaron:

```text
Authenticated Users
CREATOR OWNER
Domain Admins
SYSTEM
```

---

## Folder Redirection

La GPO utilizada fue:

```text
Roaming - Redireccion de Documentos
```

La implementación se concentró específicamente en:

```text
Documents
```

La ruta final siguió el siguiente formato:

```text
\\WIN-IORAFMP55C9\Usuarios$\<usuario>\Documents
```

Ejemplo:

```text
\\WIN-IORAFMP55C9\Usuarios$\AlanS12\Documents
```

Esto corresponde a **Folder Redirection de Documents**, no a un perfil roaming completo.

---

## Creación del directorio

La configuración permitió que el directorio correspondiente al usuario pudiera crearse automáticamente al procesarse la política.

El modelo esperado era:

```text
D:\Usuarios\
└── AlanS12\
    └── Documents\
```

---

## Modelo de acceso

La estructura buscaba mantener los documentos separados por usuario:

```text
Usuario
   │
   ▼
Su carpeta Documents
   │
   └── Lectura / Escritura
```

Los permisos del recurso raíz se combinaron con los permisos de los directorios individuales.

---

## Validación

La validación se realizó después de aplicar la política.

Proceso:

```text
1. Iniciar sesión con un usuario del dominio.
2. Permitir que se procese Group Policy.
3. Abrir Documents.
4. Verificar la redirección al servidor.
5. Verificar el directorio correspondiente en D:\Usuarios.
```

La ruta esperada fue:

```text
\\WIN-IORAFMP55C9\Usuarios$\<usuario>\Documents
```

---

## Sincronización de tiempo

El proyecto también requería que los equipos mantuvieran una hora coherente dentro del dominio.

Durante las pruebas se observó una diferencia importante en la hora y fecha mostradas por el servidor y el cliente.

La investigación mostró que una parte importante de la diferencia observada estaba relacionada con las zonas horarias configuradas en las máquinas.

Después de la corrección, la diferencia real en UTC quedó reducida a unos pocos segundos.

---

## Windows Time Service

El estado del servicio de tiempo se comprobó mediante:

```cmd
w32tm /query /status
```

También se utilizó:

```cmd
w32tm /resync /rediscover
```

para forzar la redetección de la fuente de tiempo y la sincronización.

---

## Relación con Active Directory

El problema de tiempo también tuvo impacto sobre las operaciones del dominio.

Durante la incidencia:

```cmd
gpupdate /force
```

falló debido a la diferencia de tiempo entre el cliente y el entorno del dominio.

Después de corregir la sincronización, la actualización de políticas volvió a completarse correctamente.

Esto evidenció la importancia de mantener una hora consistente para las operaciones relacionadas con Active Directory y Kerberos.

---

## Permisos administrativos

Cuando el comando:

```cmd
w32tm /resync
```

se ejecutó desde una cuenta estándar, Windows devolvió un error de acceso denegado.

Esto era esperado, ya que determinadas operaciones del servicio de tiempo requieren privilegios administrativos.

---

## Nota de troubleshooting

Durante la investigación se consideró la posibilidad de que la sincronización de VMware entre host e invitado pudiera estar influyendo.

Sin embargo, esto no quedó confirmado como la causa raíz del comportamiento documentado.

Lo que sí fue confirmado es que la corrección del estado de tiempo y la posterior resincronización permitieron recuperar el funcionamiento normal de las operaciones de dominio.

---

## Consideraciones de seguridad y disponibilidad

Centralizar los documentos facilita la administración de los datos de usuario y reduce la dependencia del almacenamiento exclusivamente local.

La sincronización de tiempo también es importante para la disponibilidad de los servicios de dominio, ya que una diferencia significativa puede interferir con Kerberos y otras operaciones de autenticación.

---

## Evidencia

```text
../../assets/05-folder-redirection/
```

Capturas sugeridas:

```text
01-usuarios-share.png
02-folder-redirection-gpo.png
03-redirected-documents.png
04-user-folder-on-server.png
05-w32tm-status.png
06-time-sync-validation.png
```

---

## Resultado

```text
✓ Almacenamiento centralizado de Documents
✓ Recurso SMB oculto Usuarios$
✓ Directorios por usuario
✓ Folder Redirection mediante GPO
✓ Sincronización de tiempo
✓ Recuperación de problemas relacionados con la hora
```