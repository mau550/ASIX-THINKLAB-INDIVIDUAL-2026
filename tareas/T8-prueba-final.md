# T8 · Prueba final: preparación y guía rápida

La T8 es un caso práctico **presencial** (25/11/2026) sobre este entorno, así que no se puede «hacer» de antemano. Aquí está lo necesario para resolverlo rápido y con método.

| RA | Criterios | Cómo llego preparado |
|---|---|---|
| FDM RA1 | a25 · a26 Diagnosticar y resolver la incidencia de hardware, justificarla y comprobarla | Método de §1 + herramientas de la [T2](T2-equipos-clase-y-casa.md) y la [T7](T7-rendimiento.md). Ensayo real: [INC-002](../incidencias/INC-002-ssd-portatil-en-usb2.md) |
| FDM RA4 | a50–a53 Equipos empresariales, puertos, alimentación, ventilación y cableado; esquema y explicación | §3 |
| ISO RA1 | a80 Incidencia de instalación, actualización o arranque | Ensayos reales: [INC-001](../incidencias/INC-001-cli-linux-pantalla-negra-sin-grub.md) (GRUB) y [INC-004](../incidencias/INC-004-instalacion-desatendida-postinstall-fallido.md) |
| ISO RA3 | a104 Recuperar la información o el sistema | Copias en el NAS **ya restauradas**: [r-mikrotik](../maquinas/r-mikrotik/README.md) (39 s), [r-nftables](../maquinas/r-nftables/README.md) (1,3 s), RAID ([T6](T6-almacenamiento-y-recuperacion.md)) |
| ISO RA6 | a122 Diagnosticar el problema de rendimiento | [T7 §6](T7-rendimiento.md) |
| Todos | a30 · a57 · a84 · a110 · a126 (Apte+) Cuestionario por RA | §4 |

## 1. Método para cualquier incidencia

1. **Síntoma exacto:** qué se ve, desde cuándo y qué ha cambiado. Hacer captura.
2. **Hipótesis**, de la más probable o barata de comprobar a la menos.
3. **Prueba** de cada hipótesis, con una orden y su salida.
4. **Solución**, guardando antes una copia de lo que se va a tocar.
5. **Verificación:** la misma prueba que fallaba ahora funciona.
6. **Vuelta atrás:** cómo se desharía.
7. Documentarlo con la [plantilla](../incidencias/plantilla.md).

## 2. Chuleta de órdenes

| Situación | Orden | Qué buscar |
|---|---|---|
| ¿Qué hardware hay? | `lscpu`, `free -h`, `lsblk -o NAME,MODEL,SIZE,TRAN`, `lspci`, `lsusb -t` | Modelo, cantidad y **velocidad del bus** (`480M` = USB 2.0) |
| ¿Se calienta? | `sensors` | Paquete de la CPU < 85 °C bajo carga |
| ¿RAM o disco? | `vmstat 5` · `iostat -xm 5` | `si/so` ≠ 0 → falta RAM · `%util` > 80 % → disco |
| ¿Por qué no arranca? | `VBox.log` · ISO en modo rescate · `journalctl -b -1 -p err` | `Booting from Hard Disk` y nada más → GRUB |
| ¿Red? | `ip -br a`, `ip r`, `ping`, `traceroute -n`, `dig` | Capa por capa: interfaz → pasarela → IP externa → DNS |
| ¿Cortafuegos? | `nft list ruleset` · `/ip firewall filter print stats` · `journalctl -k -g PREFIJO` | Contadores que suben y prefijos en el registro |
| ¿RAID? | `cat /proc/mdstat` · `mdadm --detail /dev/mdX` | `[U_]` degradado · `inactive` → `mdadm --run` |
| Restaurar un Debian | `sftp … get` + `sha256sum -c` + `tar xzf -C /` | La suma debe coincidir antes de restaurar |
| Restaurar MikroTik | `/tool fetch mode=sftp …` + `/system backup load` | Rutas **absolutas** en SFTP |

## 3. FDM RA4: equipos empresariales, conexiones, alimentación y cableado

| Equipo | Función | Puertos y conexiones típicos | Alimentación y ventilación |
|---|---|---|---|
| Router / cortafuegos (MikroTik hEX) | Une la LAN con la WAN, NAT, filtrado | 5 × RJ45 Gigabit (1 WAN + 4 LAN), consola | Adaptador externo o PoE de entrada; pasiva (sin ventilador) |
| Switch gestionable de rack | Conecta los equipos de la LAN, VLAN | 24/48 × RJ45 + 2–4 SFP/SFP+ (enlaces troncales y fibra) | Fuente interna, a veces doble (redundante); ventilación frontal → trasera |
| Servidor de rack (1U/2U) | Virtualización, dominio, ficheros | 2–4 × RJ45/SFP+, **iDRAC/iLO/IPMI** (gestión fuera de banda), USB, VGA | **Dos fuentes redundantes** a dos líneas distintas; flujo de aire de pasillo frío a pasillo caliente |
| NAS | Almacenamiento y copias | 2 × RJ45 (agregables), USB para copia externa | Fuente simple o doble; ventiladores de las bahías de disco |
| SAI (UPS) | Mantiene la alimentación y avisa del corte para apagar con orden | Tomas IEC C13, USB o red para el aviso | Dimensionar en VA/W con margen; baterías con revisión periódica |
| Patch panel + latiguillos | Ordena el cableado horizontal | 24 × RJ45, cable Cat6/Cat6A | — |

**Buenas prácticas de cableado:** etiquetar los dos extremos, separar alimentación y datos, respetar el radio de curvatura, usar colores por función (p. ej. azul datos, rojo troncales, amarillo gestión), no tapar las rejillas de ventilación y dejar el cable de la longitud justa.

## 4. Repaso para el cuestionario (por RA)

**FDM RA1 · Hardware**
- ¿Por qué el SSD rinde 41 MB/s en casa? Porque está en un puerto USB 2.0 (480 Mbit/s ≈ 40 MB/s útiles). Se demuestra con `lsusb -t` y `fio`.
- Un cuello de botella se **confirma o descarta con datos**: CPU 95 % libre → descartada; disco al 90 % → confirmado.

**ISO RA1 · Instalación y configuración**
- BIOS frente a UEFI: con BIOS, GRUB va en el MBR más el hueco hasta el sector 2048; con UEFI, en la partición EFI (FAT32).
- Por qué se verifica el SHA256 y qué hacer si el fabricante no lo publica (anotarlo y descargar solo por HTTPS de la web oficial).
- Servidor con IP fija y cliente por DHCP; un solo router con la pasarela .1.

**ISO RA3 · Almacenamiento y recuperación**
- RAID 0, 1 y 5: capacidad, tolerancia y uso (ver la [T6](T6-almacenamiento-y-recuperacion.md)). **RAID ≠ copia.**
- Regla 3-2-1: 3 copias, 2 soportes, 1 fuera.
- Qué se copia: configuración y datos. Qué no: el sistema, que se reinstala.

**ISO RA6 · Rendimiento**
- `vmstat`, `iostat`, `free`, `pidstat`: qué columna mirar en cada uno.
- Cuántas VM caben: suma de la RAM asignada ≤ RAM física − 4 GB, y sin *swap* sostenida.

## 5. Antes del día de la prueba

- [ ] Cambiar el SSD a un puerto USB 3.x y repetir `fio` ([INC-002](../incidencias/INC-002-ssd-portatil-en-usb2.md)).
- [ ] Instantánea de las VM configuradas: `VBoxManage snapshot <vm> take antes-T8`.
- [ ] Comprobar que las copias del NAS son recientes (`journalctl -t copia-config`).
- [ ] Credenciales a mano (fichero fuera del repositorio).
