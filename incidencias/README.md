# Registro de incidencias

| ID | Máquina | Tipo | Resumen | Estado |
|---|---|---|---|---|
| [INC-001](INC-001-cli-linux-pantalla-negra-sin-grub.md) | `cli-linux` | Instalación / arranque | Pantalla negra: el instalador no escribió GRUB (`Installing grub on ''`) → modo rescate + `grub-install` | ✅ |
| [INC-002](INC-002-ssd-portatil-en-usb2.md) | Anfitrión (casa) | Hardware / rendimiento | SSD del laboratorio en USB 2.0: 41 MB/s, disco al 80–93 % | 🔎 Falta cambiar de puerto |
| [INC-003](INC-003-cli-win11-apagado-colgado.md) | `cli-win11` | Apagado / rendimiento | Windows se cuelga al apagarse por E/S lenta (`AHCI#0: Port 0 reset`) | ✅ |
| [INC-004](INC-004-instalacion-desatendida-postinstall-fallido.md) | `r-nftables`, `srv-linux` | Instalación | Falla el *post-install* de la instalación desatendida: sin `sudo` ni actualizaciones | ✅ |
| [INC-005](INC-005-truenas-cambio-de-ip-revertido.md) | `nas-truenas` | Red | El cambio a IP fija se revierte solo por falta de *checkin* | ✅ |
| [INC-006](INC-006-mikrotik-sftp-status-4.md) | `r-mikrotik` | Copias | `/tool fetch` SFTP falla con ruta relativa (`status 4`) | ✅ |
| [INC-007](INC-007-debian-hora-y-dns-tras-cambiar-red.md) | `srv-linux`, `r-nftables` | Configuración | Hora +1 h (RTC) y `resolv.conf` vacío al pasar a IP fija | ✅ |

Plantilla: [plantilla.md](plantilla.md).
