# `cli-linux` · Cliente GNU/Linux (Debian 13 con GNOME)

| Dato | Valor |
|---|---|
| Función | Cliente de escritorio GNU/Linux de la empresa |
| Sistema | Debian GNU/Linux **13.8** «trixie» con GNOME, núcleo 6.12.117 (era 13.7 antes de actualizar) |
| Recursos | 1 vCPU · 2 GB RAM · disco VDI dinámico de 20 GB (7,8 GB ocupados) · BIOS |
| Red | `lan-iso` por DHCP (192.168.29.105) · nombre de equipo `debian-mauro` |
| Usuarios | `mauro` («mauro bas», uso diario, sin sudo) · **`adminlab`** (administración, sudo) |
| Nombre anterior | «Debian 13.1» (renombrada el 22/11 para seguir la nomenclatura del laboratorio) |
| Configuración VirtualBox | [config/virtualbox-showvminfo.txt](config/virtualbox-showvminfo.txt) |

> **Corrección:** en la T0 y la T5 anteriores esta máquina figuraba como «Debian 13.1 con pantalla negra, causa no determinada» y, en otro sitio, como futuro servidor Linux. Ahora es el **cliente Linux**; el servidor es [`srv-linux`](../srv-linux/README.md), instalado sin escritorio. La versión real es la **13.7**: la instalación desde la netinst 13.1 descargó los paquetes actualizados.

## Estado por criterio de la rúbrica

| Criterio | Estado | Evidencia |
|---|---|---|
| a252 Instalar, versión y funcionamiento | ✅ | Arranca hasta GDM tras [INC-001](../../incidencias/INC-001-cli-linux-pantalla-negra-sin-grub.md) · ahora **Debian 13.8**, núcleo 6.12.117 |
| a80 · a26 Incidencia de instalación/arranque | ✅ | [INC-001](../../incidencias/INC-001-cli-linux-pantalla-negra-sin-grub.md): GRUB no instalado → modo rescate → `grub-install /dev/sda` |
| **a253** Usuario de administración | ✅ | **`adminlab`** (grupos `sudo` y `adm`, SSH con clave), creado desde el modo rescate. La cuenta personal `mauro` («mauro bas») **no se tocó** y queda como usuario sin privilegios · [cl-01](capturas/cl-01-rescate-crear-adminlab.png) · [01-version-usuarios-red.txt](salidas/01-version-usuarios-red.txt) |
| **a254** Parámetros de red | ✅ | `lan-iso` por **DHCP** de r-opnsense: 192.168.29.105/24, pasarela .1 (NetworkManager) · ping a la pasarela e Internet correcto |
| a79 Actualizar | ✅ | Repositorios a **HTTPS** (el router bloquea el puerto 80) + `full-upgrade` de 121 paquetes → 13.8 · [02-repos-https-actualizacion.txt](salidas/02-repos-https-actualizacion.txt) |
| **a255** Copia al servidor de copias | ✅ | `copia-config.timer` diario → SFTP con clave a `c-clilinux` · [03-copia-automatica-al-nas.txt](salidas/03-copia-automatica-al-nas.txt) |

## Capturas

| # | Qué muestra |
|---|---|
| [inc001-00](capturas/inc001-00-pantalla-negra.png) | Síntoma: pantalla negra con cursor |
| [inc001-01…12](capturas/) | Arranque de la ISO en modo rescate, paso a paso |
| [inc001-13](capturas/inc001-13.png) | Sistema completo: Debian 13.7, núcleos y `grub-pc` instalados |
| [inc001-14](capturas/inc001-14.png) | `grub-install /dev/sda` + `update-grub` sin errores |
| [inc001-17](capturas/inc001-17.png) | Pantalla de inicio de sesión de GNOME |
| [cl-01](capturas/cl-01-rescate-crear-adminlab.png) | Creación del administrador `adminlab` desde el modo rescate |

## ¿Por qué un administrador aparte?

La cuenta personal (`mauro`) no estaba en `sudo` y no conozco su contraseña. En lugar de cambiarla, se creó desde el modo rescate de la ISO (como en [INC-001](../../incidencias/INC-001-cli-linux-pantalla-negra-sin-grub.md)) una cuenta **`adminlab`** solo para administrar. Es la práctica habitual en empresa: **separar la cuenta de uso diario de la de administración** (privilegio mínimo).

## Copia: qué se copia y qué no

| Se copia | No se copia | Motivo |
|---|---|---|
| `/etc` + lista de paquetes (`dpkg --get-selections`) + `/home/mauro` (1,1 MB) | El sistema (7,8 GB) | Debian se reinstala en 15 min; la configuración y los datos del usuario son lo único que no se recupera de otra forma |
