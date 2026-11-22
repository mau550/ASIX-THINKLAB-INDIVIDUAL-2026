# T5 · Comparación de las tres soluciones de comunicaciones

Las tres se montaron con **la misma red** (WAN por NAT, LAN 192.168.29.1/24), las **mismas pruebas** (HTTPS permitido y HTTP bloqueado con registro) y la **misma prueba de fallo** (configuración rota → restaurar desde el NAS). Así se pueden comparar en igualdad de condiciones.

| | [`r-mikrotik`](../maquinas/r-mikrotik/README.md) | [`r-opnsense`](../maquinas/r-opnsense/README.md) | [`r-nftables`](../maquinas/r-nftables/README.md) |
|---|---|---|---|
| Sistema | RouterOS 7.24.5 (CHR) | OPNsense 26.7.9_3 (FreeBSD) | Debian 13.8 + nftables + dnsmasq |
| Licencia | Propietaria (CHR *free*: 1 Mbit/s de subida por interfaz) | BSD-2, libre | Libre (DFSG) |
| RAM asignada / usada | 256 MB / ~183 MB | 2 GB (3 GB para instalar) | 1 GB / ~0,2 GB |
| Instalación | Disco virtual ya hecho (`.vdi`): **segundos** | Instalador de texto (~15 min) | Instalación desatendida de Debian (~20 min) + configuración a mano |
| Administración | CLI y WebFig; SSH con clave | **Web** y **API REST** | SSH y ficheros de texto |
| Usuario propio | `mauro` (*full*), `admin` desactivado | `mauro` (grupo `admins`) | `mauro` (`sudo`) |
| Orden de reglas | Por posición en la lista | **Por número de secuencia** ([INC-010](../incidencias/INC-010-opnsense-regla-de-bloqueo-que-no-bloquea.md)) | Por orden dentro de la cadena |
| Registro | `/log` (`log-prefix`) | *Live View* con colores y filtros | `journalctl -k` (prefijo de la regla) |
| Copia | `.backup` binario cifrado + `.rsc` de texto | `config.xml` (lo cifro yo con AES-256) | `tar.gz` de 6 ficheros (4 KB) |
| Automatización de la copia | `/system scheduler` (en el propio router) | Script desde fuera (API) | `systemd` timer (en el propio router) |
| **Recuperación medida** | **39 s** (incluye reinicio) | **69 s** (incluye reinicio) | **1,3 s** (sin reinicio) |
| Curva de aprendizaje | Media (sintaxis propia de RouterOS) | **Baja** (todo en la web) | Alta (hay que saber Linux y nftables) |

## ¿Cuál elegiría para la empresa?

| Escenario | Elección | Por qué |
|---|---|---|
| Oficina pequeña, sin informático a tiempo completo | **OPNsense** | Interfaz web clara, actualizaciones con un clic, registro visual y muchas funciones (VPN, IDS) sin programar nada |
| Sede con hardware de red dedicado | **MikroTik** (físico, como el hEX del grupo) | Muy barato, poco consumo y fiable; la configuración cabe en un `.rsc` de 2,5 KB |
| Equipo técnico con experiencia en Linux que quiere control total | **nftables** | Ligero, transparente (todo es texto, versionable en Git) y la restauración más rápida |

**Para la empresa del proyecto** (5 departamentos, un informático): **OPNsense** como cortafuegos principal, por su facilidad de gestión y de auditoría (registro web). nftables queda como solución de respaldo para entornos Linux.
