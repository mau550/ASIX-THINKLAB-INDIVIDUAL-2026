# Chuleta de la defensa: las máquinas en 30 segundos cada una

Para tenerla abierta durante la defensa y la prueba final. El detalle está en la ficha de cada máquina.

**Orden de arranque:** router activo → `nas-truenas` → lo que toque. **Un solo router con la LAN conectada** (`VBoxManage controlvm <router> setlinkstate2 on|off`).
**Credenciales:** en `~/Escritorio/1 ASIX/ISO/credenciales-lab.txt` (fuera del repositorio).

| Máquina | IP | Entrar | Enseñar | Frase clave |
|---|---|---|---|---|
| `r-mikrotik` | .1 | `ssh -p 2211 mauro@127.0.0.1` · WebFig `127.0.0.1:8011` | `/ip firewall filter print stats` · `/log print where message~"HTTP"` | «Gana la primera regla que coincide; uso `in-interface=ether2` porque filtro lo que **entra** desde la LAN» |
| `r-opnsense` | .1 | Web `https://192.168.29.1` (desde la LAN) | *Firewall › Rules* (secuencias 50/51/100) · *Live View* | «Mi bloqueo no funcionaba porque *Default allow* tenía la secuencia 1: lo moví a la 100» |
| `r-nftables` | .1 | `ssh -p 2201 mauro@127.0.0.1` | `sudo nft list ruleset` · `journalctl -k -g BLOQUEO` · `cat /proc/sys/net/ipv4/ip_forward` | «Política `drop` y abro solo lo necesario; la NAT es `masquerade`; recupero el router en 1,3 s desde el NAS» |
| `nas-truenas` | .10 | Web `https://192.168.29.10` | *Datasets* (uno por máquina) · *Users* (`c-*`) | «Un usuario y una carpeta por equipo: si roban la clave de un router, no puede tocar las copias del dominio» |
| `srv-dc` | .13 | Consola · `iso29\mauro` | *Usuarios y equipos de AD* (OU por departamento) · GPO · `Get-ScheduledTaskInfo 'Copia AD al NAS'` | «Un dominio = una cuenta por persona y normas (GPO) para todos los equipos desde un sitio» |
| `srv-linux` | .14 | `ssh mauro@192.168.29.14` (por el router) | `cat /proc/mdstat` · `cat /proc/drbd` · `systemctl list-timers` | «RAID 0 lo perdí al quitar un disco; RAID 1 y 5 siguieron con los datos intactos. **Un RAID no es una copia**» |
| `srv-linux2` | .16 | `ssh mauro@192.168.29.16` | `cat /proc/drbd` | «DRBD = RAID 1 por red entre dos equipos: si se apaga srv-linux, srv-linux2 tiene los datos en 3,5 s» |
| `cli-linux` | DHCP (.105) | `ssh adminlab@…` | `id adminlab` · `ip r` | «Separé la cuenta de uso diario de la de administración» |
| `cli-win11` | — | Consola | — | «Instalado y arranca; falta iniciar sesión para configurarlo» |
| `pve1-3` | .11/.12/.15 | — | — | «3 nodos por el quórum: con 2, si cae uno, el otro se bloquea» |

## Cifras que conviene recordar

| Qué | Dato |
|---|---|
| Disco del laboratorio en casa | USB 2.0 → **41 MB/s**, al 80–93 % con una sola VM de Windows ([INC-002](../incidencias/INC-002-ssd-portatil-en-usb2.md)) |
| VM a la vez en casa (16 GB) | 2 de escritorio, o router + NAS + 1–2 servidores; el clúster Proxmox solo en clase |
| Servidor sin escritorio | 211 MB de RAM usados, arranque en 7,5 s |
| Recuperación de routers | MikroTik 39 s · OPNsense 69 s · nftables 1,3 s |
| RAID | Reconstrucción en 13 s · RAID 0 se pierde · RAID 1 y 5 sobreviven |
| DRBD | Sincronización de 1 GB en 55 s · relevo en 3,5 s |
| Incidencias reales documentadas | 11 ([registro](../incidencias/README.md)) |

## Si en la prueba me piden…

| Me piden | Voy a | Primera orden |
|---|---|---|
| «No arranca» | [INC-001](../incidencias/INC-001-cli-linux-pantalla-negra-sin-grub.md) | ¿Aparece GRUB? → ISO en modo rescate |
| «Va lento» | [T7](../tareas/T7-rendimiento.md) | `vmstat 5` · `iostat -xm 5` · `free -m` |
| «Sin Internet en la LAN» | Ficha del router | `ping` a la pasarela → `ping 1.1.1.1` → `dig` → reglas y NAT |
| «Recupera la configuración» | [Plan de copias](../tareas/T5-plan-de-copias.md) | `sftp … get` + `sha256sum -c` + restaurar |
| «Se ha roto un disco» | [T6](../tareas/T6-almacenamiento-y-recuperacion.md) | `cat /proc/mdstat` → `mdadm --run` → `--add` |
