# Registro de incidencias

| ID | Máquina | Tipo | Resumen | Estado |
|---|---|---|---|---|
| [INC-001](INC-001-cli-linux-pantalla-negra-sin-grub.md) | `cli-linux` | Instalación / arranque | Pantalla negra: el instalador no escribió GRUB (`Installing grub on ''`) → modo rescate + `grub-install` | ✅ |
| [INC-002](INC-002-ssd-portatil-en-usb2.md) | Anfitrión (casa) | Hardware / rendimiento | SSD del laboratorio en USB 2.0: 41 MB/s, disco al 80–93 % | ✅ Mitigada · cambio de puerto propuesto |
| [INC-003](INC-003-cli-win11-apagado-colgado.md) | `cli-win11` | Apagado / rendimiento | Windows se cuelga al apagarse por E/S lenta (`AHCI#0: Port 0 reset`) | ✅ |
| [INC-004](INC-004-instalacion-desatendida-postinstall-fallido.md) | `r-nftables`, `srv-linux` | Instalación | Falla el *post-install* de la instalación desatendida: sin `sudo` ni actualizaciones | ✅ |
| [INC-005](INC-005-truenas-cambio-de-ip-revertido.md) | `nas-truenas` | Red | El cambio a IP fija se revierte solo por falta de *checkin* | ✅ |
| [INC-006](INC-006-mikrotik-sftp-status-4.md) | `r-mikrotik` | Copias | `/tool fetch` SFTP falla con ruta relativa (`status 4`) | ✅ |
| [INC-007](INC-007-debian-hora-y-dns-tras-cambiar-red.md) | `srv-linux`, `r-nftables` | Configuración | Hora +1 h (RTC) y `resolv.conf` vacío al pasar a IP fija | ✅ |
| [INC-008](INC-008-windows-crl-bloqueada-por-http.md) | `srv-dc` / `r-opnsense` | Red | Windows no valida certificados: la CRL/OCSP va por HTTP y está bloqueado | 🔎 Explicada |
| [INC-009](INC-009-scp-como-system-clave-desprotegida.md) | `srv-dc` | Copias | `scp` como SYSTEM rechaza la clave: propietario incorrecto | ✅ |
| [INC-010](INC-010-opnsense-regla-de-bloqueo-que-no-bloquea.md) | `r-opnsense` | Cortafuegos | La regla de bloqueo estaba detrás de *Default allow* | ✅ |
| [INC-011](INC-011-ad-samaccountname-20-caracteres.md) | `srv-dc` | Dominio | `sAMAccountName` de más de 20 caracteres | ✅ |

Plantilla: [plantilla.md](plantilla.md).
