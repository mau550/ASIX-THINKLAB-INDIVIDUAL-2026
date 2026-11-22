# `cli-linux` · Cliente GNU/Linux (Debian 13 con GNOME)

| Dato | Valor |
|---|---|
| Función | Cliente de escritorio GNU/Linux de la empresa |
| Sistema | Debian GNU/Linux **13.7** «trixie» con GNOME (núcleos 6.12.43 y 6.12.107) |
| Recursos | 1 vCPU · 2 GB RAM · disco VDI dinámico de 20 GB (7,8 GB ocupados) · BIOS |
| Red | Adaptador 1: NAT (hoy) → previsto `lan-iso` por DHCP (.100–.200) |
| Usuario | `mauro bas` (creado en la instalación de septiembre) |
| Nombre anterior | «Debian 13.1» (renombrada el 22/11 para seguir la nomenclatura del laboratorio) |
| Configuración VirtualBox | [config/virtualbox-showvminfo.txt](config/virtualbox-showvminfo.txt) |

> **Corrección:** en la T0 y la T5 anteriores esta máquina figuraba como «Debian 13.1 con pantalla negra, causa no determinada» y, en otro sitio, como futuro servidor Linux. Ahora es el **cliente Linux**; el servidor es [`srv-linux`](../srv-linux/README.md), instalado sin escritorio. La versión real es la **13.7**: la instalación desde la netinst 13.1 descargó los paquetes actualizados.

## Estado por criterio de la rúbrica

| Criterio | Estado | Evidencia |
|---|---|---|
| a252 Instalar y comprobar versión y funcionamiento | ✅ | Arranca hasta GDM tras [INC-001](../../incidencias/INC-001-cli-linux-pantalla-negra-sin-grub.md); `/etc/debian_version` = 13.7 ([captura](capturas/inc001-13.png)) |
| a80 · a26 Resolver una incidencia de instalación/arranque | ✅ | [INC-001](../../incidencias/INC-001-cli-linux-pantalla-negra-sin-grub.md): GRUB no instalado → modo rescate → `grub-install /dev/sda` |
| a253 Usuario de administración | ⏳ | Falta comprobar con `id mauro` y `sudo -l` (necesita la contraseña del usuario) |
| a254 Parámetros de red | ⏳ | Pasar el adaptador a `lan-iso` y comprobar la IP por DHCP del router |
| a255 Copiar la configuración al servidor de copias | ⏳ | Ver «Pasos pendientes» |

## Capturas

| # | Qué muestra |
|---|---|
| [inc001-00](capturas/inc001-00-pantalla-negra.png) | Síntoma: pantalla negra con cursor |
| [inc001-01…12](capturas/) | Arranque de la ISO en modo rescate, paso a paso |
| [inc001-13](capturas/inc001-13.png) | Sistema completo: Debian 13.7, núcleos y `grub-pc` instalados |
| [inc001-14](capturas/inc001-14.png) | `grub-install /dev/sda` + `update-grub` sin errores |
| [inc001-16](capturas/inc001-16.png) | El núcleo carga desde el disco |
| [inc001-17](capturas/inc001-17.png) | Pantalla de inicio de sesión de GNOME |

## Pasos pendientes (con la sesión gráfica iniciada)

```bash
# 1. Usuario administrador
id mauro ; sudo -l

# 2. Red: apagar la VM y, en el anfitrión:
VBoxManage modifyvm cli-linux --nic1 intnet --intnet1 lan-iso
#    Al arrancar, comprobar la concesión DHCP del router:
ip -br a ; ip route ; resolvectl status | grep 'DNS Servers'

# 3. Copia de la configuración y de los documentos al NAS (SFTP con clave, usuario cli-linux)
tar czf /tmp/cli-linux-$(date +%F).tar.gz /etc /home/mauro/Documentos
sftp cli-linux@192.168.29.10 <<< 'put /tmp/cli-linux-*.tar.gz'
```

**Qué se copia y qué no:** se copian `/etc` (configuración) y los documentos del usuario. **No** se copia el sistema entero (7,8 GB): Debian se reinstala en 15 minutos desde la ISO y los programas se recuperan con la lista de `dpkg --get-selections`.
