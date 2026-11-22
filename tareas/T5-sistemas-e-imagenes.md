# T5 · Instalación y comunicaciones: sistemas, imágenes y comprobaciones generales

Este documento recoge lo **común** a todas las instalaciones. El detalle de cada sistema está en la ficha de su máquina ([`maquinas/`](../maquinas/)).

Documentos relacionados: [comparación de los tres routers](T5-comparacion-routers.md) · [plan de copias de seguridad](T5-plan-de-copias.md).

| RA | Criterio | Estado |
|---|---|---|
| ISO RA1 | a78 Requisitos y origen de las imágenes; verificar su integridad | ✅ §1 y §2 |
| ISO RA1 | a79 Actualizar y comprobar antes de poner en producción | ✅ `r-nftables`, `srv-linux`, `cli-linux` (13.8), `r-opnsense` (26.7 → 26.7.9_3) · ⏳ Proxmox |
| ISO RA1 | a258 Posibles problemas, configuraciones críticas y tiempos de respuesta | ✅ §4 |
| ISO RA1 | a259 Preparar el espacio de copias en TrueNAS: qué, cómo y dónde | ✅ [nas-truenas §2](../maquinas/nas-truenas/README.md) |
| ISO RA3 | a105 (Apte+) Automatizar las copias | ✅ §3 |

## 1. Sistemas elegidos (versiones reales instaladas)

> **Correcciones respecto a la versión del 17/11:** había versiones y recursos distintos según el documento (RouterOS 7.24.6 frente a 7.24.5; TrueNAS 25.10.8 frente a 25.10.7, con 4 GB frente a 8 GB; OPNsense 26.7.9 frente a 26.7; Proxmox 4 vCPU/6 GB/20 GB frente a 2/4/32; cliente Linux Ubuntu frente a Debian). Aquí queda **una sola tabla** con lo que realmente se ha descargado, verificado e instalado.

| Función | Máquina | Sistema y versión | Licencia | Estado |
|---|---|---|---|---|
| Router 1 | [`r-mikrotik`](../maquinas/r-mikrotik/README.md) | MikroTik RouterOS **CHR 7.24.5** | Propietaria; CHR *free* (1 Mbit/s de subida por interfaz) | ✅ Instalado y configurado |
| Router 2 | [`r-opnsense`](../maquinas/r-opnsense/README.md) | OPNsense **26.7.9_3** | BSD-2 | ✅ Instalado y configurado |
| Router 3 | [`r-nftables`](../maquinas/r-nftables/README.md) | Debian **13.8** sin escritorio + nftables + dnsmasq | Libre (DFSG) | ✅ Instalado y configurado |
| NAS / copias | [`nas-truenas`](../maquinas/nas-truenas/README.md) | TrueNAS **25.10.7** Community «Goldeye» | GPL; soporte de pago opcional | ✅ Instalado y configurado |
| Virtualización | [`pve1-3`](../maquinas/pve1/README.md) | Proxmox VE **9.2.2** | AGPLv3; repositorio *enterprise* de pago | ✅ Clúster de 3 nodos con quórum y migraciones |
| Dominio | [`srv-dc`](../maquinas/srv-dc/README.md) | Windows Server 2025 Standard Evaluation (26100) | Propietaria; evaluación 180 días | ✅ DC de `iso29.lan` |
| Servidor Linux | [`srv-linux`](../maquinas/srv-linux/README.md) | Debian **13.8** sin escritorio | Libre (DFSG) | ✅ Instalado, configurado, RAID |
| Cliente Windows | [`cli-win11`](../maquinas/cli-win11/README.md) | Windows 11 (`w11.iso`) | Propietaria; sin activar | ✅ Windows 11 Pro 23H2, instalación desatendida, unido a `iso29.lan` |
| Cliente Linux | [`cli-linux`](../maquinas/cli-linux/README.md) | Debian **13.8** con GNOME | Libre (DFSG) | ✅ Reparado ([INC-001](../incidencias/INC-001-cli-linux-pantalla-negra-sin-grub.md)) y configurado |

### Requisitos mínimos oficiales frente a lo asignado

| Sistema | Mínimo oficial | Asignado | Valoración |
|---|---|---|---|
| RouterOS CHR | 1 CPU, 128 MB RAM, 128 MB disco | 1 vCPU · 256 MB · 89 MB | ✅ Usa 183 MB reales |
| OPNsense | 1 GB RAM, 2 núcleos recomendados, 8–40 GB | 2 vCPU · 2 GB · 20 GB | ✅ |
| Debian 13 sin escritorio | 512 MB (instalador), 2 GB disco | 1 vCPU · 1 GB · 8–10 GB | ✅ Usa 211 MB |
| Debian 13 con GNOME | 2 GB RAM, 10 GB | 1 vCPU · 2 GB · 20 GB | ⚠️ Justo; 1 vCPU la hace lenta |
| TrueNAS 25.10 | **8 GB RAM**, 2 núcleos, disco de arranque de 16 GB + discos de datos | 2 vCPU · 8 GB · 20 GB + 20 GB | ✅ Cumple el mínimo |
| Proxmox VE 9 | CPU de 64 bits con VT-x, 2 GB RAM + la de las VM | 2 vCPU · 4 GB · 32 GB · VT-x anidada | ✅ Para pruebas |
| Windows Server 2025 | 2 GB (con escritorio), 32 GB, UEFI y TPM 2.0 recomendados | 2 vCPU · 4 GB · 50 GB · UEFI + TPM | ✅ |
| Windows 11 | 4 GB, 64 GB, UEFI + Secure Boot + TPM 2.0 | 2 vCPU · 4 GB · 80 GB · UEFI + SB + TPM | ✅ |

Fuentes consultadas el 20/11/2026: documentación oficial de cada fabricante (enlaces en la [T1](T1-necesidades-y-requisitos.md)).

## 2. Origen e integridad de las imágenes (a78)

Todas descargadas **por HTTPS de la web oficial** del fabricante. Se calcula `sha256sum` y se compara con la suma que publica el propio fabricante. Resultado: [anexos/sha256-imagenes-20261122.txt](../anexos/sha256-imagenes-20261122.txt) (y el registro anterior del 17/11: [sha256-isos-20261117.txt](../anexos/sha256-isos-20261117.txt)).

| Imagen | SHA256 calculado | Valor oficial | Resultado |
|---|---|---|---|
| `chr-7.24.5.vdi.zip` | `c5e33cbc…f643c4c66` | `.sha256` de download.mikrotik.com | ✅ Coincide |
| `TrueNAS-SCALE-25.10.7.iso` | `54ce9441…a007c8e` | `.sha256` de download.sys.truenas.net | ✅ Coincide |
| `proxmox-ve_9.2-1.iso` | `4e88fe41…3ef2c6c` | `SHA256SUMS` de enterprise.proxmox.com | ✅ Coincide |
| `debian-13.1.0-amd64-netinst.iso` | `658b28e2…c65568b3` | `SHA256SUMS` de cdimage.debian.org | ✅ Coincide |
| `OPNsense-26.7-dvd-amd64.iso.bz2` | `95cafedd…186bfb` | `checksums-amd64.sha256` de pkg.opnsense.org | ✅ Coincide (OPNsense publica la suma del `.bz2`) |
| `OPNsense-26.7-dvd-amd64.iso` (descomprimida) | `1efd5dc9…d5dcd` | — | Igual al valor anotado el 17/11 |
| `w11.iso` (usada en `cli-win11`) | `5210deed…89119dc8` | Microsoft no publica la suma de esta imagen | ⚠️ **N/C** |
| `26100.1742…SERVER_EVAL_x64FRE_en-us.iso` (Evaluation Center, 6,0 GB) | `d0ef4502…9b23d` | Microsoft no publica la suma | ⚠️ **N/C** (descargada de `go.microsoft.com` por HTTPS) |

> **Corrección:** el 17/11 figuraba para Windows 11 la suma `5f53774d…`, de otro fichero (`win11.iso` 25H2). La imagen con la que está instalada `cli-win11` es la `w11.iso` del disco, cuya suma es `5210deed…`. No se puede comparar con un valor oficial.

**Por qué comprobarlo:** la suma SHA256 es la huella del fichero. Si cambia un solo bit, la huella es otra. Que coincida con la del fabricante demuestra que la descarga está completa y que nadie ha modificado la imagen por el camino.

## 3. Copias de configuración automatizadas (a105)

| Máquina | Herramienta | Programación | Destino |
|---|---|---|---|
| `r-mikrotik` | Script de RouterOS [`copia-al-nas.rsc`](../maquinas/r-mikrotik/config/copia-al-nas.rsc) | `/system scheduler`, diario a las 02:30 | `nas-truenas:/mnt/copias/r-mikrotik` (SFTP) |
| `r-nftables` | [`scripts/copia-config.sh`](../scripts/copia-config.sh) | `copia-config.timer` (systemd), diario a las 02:00 | `/mnt/copias/r-nftables` (SFTP con clave) |
| `srv-linux` | El mismo script con otro [`copia-config.conf`](../maquinas/srv-linux/config/copia-config.conf) | Igual | `/mnt/copias/srv-linux` |

Las tres copias se han **restaurado de verdad** en pruebas de fallo provocado: [r-mikrotik](../maquinas/r-mikrotik/README.md#5-fallo-provocado-y-recuperación-a209) (39 s) y [r-nftables](../maquinas/r-nftables/README.md#4-fallo-provocado-y-recuperación-a223) (1,3 s).

## 4. Posibles problemas, configuraciones críticas y tiempos de respuesta (a258)

| Sistema | Configuración crítica | Problema típico | Cómo se detecta | Tiempo de respuesta medido |
|---|---|---|---|---|
| Cualquier Debian | Cargador de arranque (GRUB) | Sin GRUB en el MBR → pantalla negra con cursor | La BIOS dice `Booting from Hard Disk` y no aparece el menú | ≈ 4 min con la ISO en modo rescate ([INC-001](../incidencias/INC-001-cli-linux-pantalla-negra-sin-grub.md)) |
| Debian instalado automáticamente | Paquetes y grupos del usuario | Falla el *post-install* → sin `sudo` ni actualizaciones | Comprobar `id`, `sudo -v` y `apt list --upgradable` después de instalar | ≈ 3 min ([INC-004](../incidencias/INC-004-instalacion-desatendida-postinstall-fallido.md)) |
| Routers | Reglas NAT y de filtrado | Una regla borrada o mal ordenada → la LAN sin Internet | `curl` desde un cliente + registro del cortafuegos | **39 s** MikroTik · **1,3 s** nftables (restaurando desde el NAS) |
| TrueNAS | IP de administración | Cambio de IP que deja el equipo inaccesible | El *checkin* no llega → vuelve atrás solo | 90–120 s automáticos ([INC-005](../incidencias/INC-005-truenas-cambio-de-ip-revertido.md)) |
| RAID | `mdadm.conf` + `initramfs` + `fstab nofail` | Disco averiado → arrays `inactive` al arrancar | `cat /proc/mdstat` | `mdadm --run` inmediato · reconstrucción en 13 s ([T6](T6-almacenamiento-y-recuperacion.md)) |
| Windows 11 | Disco | Apagado colgado por E/S lenta | `iostat`, `VBox.log` (`AHCI#0: Port 0 reset`) | Apagado forzado + arranque < 2 min ([INC-003](../incidencias/INC-003-cli-win11-apagado-colgado.md)) |
| Linux en VirtualBox | Reloj RTC en UTC | Hora adelantada 1 h → registros y Kerberos con hora incorrecta | Comparar `date` en el invitado y el anfitrión | `--rtc-use-utc on` + reinicio ([INC-007](../incidencias/INC-007-debian-hora-y-dns-tras-cambiar-red.md)) |
| Todos | Repositorios | El router corta HTTP → `apt update` falla | `apt update` muestra *timeout* en el puerto 80 | Cambiar a repositorios HTTPS |
