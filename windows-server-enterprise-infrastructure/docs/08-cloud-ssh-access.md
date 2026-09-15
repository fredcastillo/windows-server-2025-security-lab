# 08 — Acceso Cloud mediante SSH

## Contexto

El proyecto final requería integrar una máquina Linux en un entorno cloud y demostrar el acceso remoto mediante autenticación basada en certificados o claves.

La implementación final utilizó:

```text
Cloud Provider: AWS
Service: EC2
Operating System: Ubuntu Linux
Protocol: SSH
Authentication: Private Key
```

AWS fue utilizado en lugar de Azure, manteniendo el objetivo funcional de la asignación.

---

## Arquitectura

La máquina Linux se desplegó como una instancia EC2.

El acceso se realizó mediante una clave privada:

```text
.pem
```

El modelo de autenticación fue:

```text
Windows environment
       │
       │ SSH
       │
       ▼
AWS EC2
Ubuntu Linux
```

No se utilizó una contraseña de usuario para la autenticación SSH.

---

## Instancia EC2

La instancia utilizó Ubuntu Linux como sistema operativo.

La configuración de la instancia siguió el diseño definido para el laboratorio y permitió realizar la conexión desde el entorno Windows utilizado durante el proyecto.

---

## Security Group

El acceso SSH se proporcionó mediante:

```text
TCP/22
```

El Security Group de la instancia permitió el tráfico SSH necesario para realizar la demostración.

El acceso se limitó al origen definido durante la configuración del laboratorio en lugar de habilitar indiscriminadamente todos los puertos.

---

## Clave privada

La autenticación utilizó una clave privada con extensión:

```text
.pem
```

La clave debía tener permisos restrictivos en Windows.

Ejemplo:

```powershell
icacls C:\ruta\clave.pem /inheritance:r
icacls C:\ruta\clave.pem /grant:r "$($env:USERNAME):(R)"
```

La clave privada nunca debe incluirse en el repositorio.

---

## Conexión SSH

El usuario utilizado para Ubuntu fue:

```text
ubuntu
```

La conexión se realizó con:

```powershell
ssh -i C:\ruta\clave.pem ubuntu@<IP-publica-EC2>
```

La dirección pública real utilizada durante la práctica no debe almacenarse en la documentación si deja de ser necesaria o si la instancia ya no está activa.

---

## Validación

El objetivo de la prueba era demostrar que el entorno Windows podía iniciar una sesión SSH hacia la máquina Linux.

La validación consistió en:

```text
1. Tener disponible la clave privada.
2. Verificar permisos de la clave.
3. Ejecutar SSH.
4. Autenticarse mediante la clave.
5. Obtener una sesión en Ubuntu.
```

La demostración quedó registrada en el video del proyecto.

---

## Consideraciones de seguridad

La autenticación mediante clave privada evita depender de una contraseña SSH.

La clave privada debe protegerse adecuadamente y nunca almacenarse en:

```text
GitHub
README
Scripts públicos
Screenshots
Issues
```

También debe evitarse publicar:

- IPs públicas que no sean necesarias
- Claves privadas
- Access Keys de AWS
- Secret Keys
- Tokens
- Credenciales

---

## AWS y el proyecto

La integración de AWS cumplió la función de demostrar que la infraestructura del proyecto podía utilizar una máquina Linux fuera del entorno Windows local.

El flujo final fue:

```text
Windows infrastructure
        │
        │ SSH
        │
        ▼
AWS EC2
        │
        ▼
Ubuntu Linux
```

---

## Evidencia

Las capturas se almacenarán en:

```text
../../assets/08-aws/
```

Archivos sugeridos:

```text
01-ec2-instance.png
02-security-group-ssh.png
03-private-key-permissions.png
04-ssh-command.png
05-ssh-authenticated.png
06-ubuntu-validation.png
```

---

## Buenas prácticas para el repositorio

No se debe incluir la clave:

```text
*.pem
```

en Git.

Se recomienda utilizar un `.gitignore` que incluya:

```gitignore
*.pem
*.key
.env
```

---

## Resultado

La implementación demostró:

```text
✓ Instancia Linux en AWS EC2
✓ Ubuntu Linux
✓ Acceso SSH
✓ Autenticación mediante clave privada
✓ Comunicación desde el entorno del proyecto
✓ Protección de información sensible
```

La integración cloud complementó la infraestructura Windows con un componente Linux externo.