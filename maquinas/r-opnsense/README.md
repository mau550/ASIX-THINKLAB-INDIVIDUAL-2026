# `r-opnsense` · Router 2 · OPNsense

> **Estado: ⏳ VM creada y con la ISO verificada montada. Falta instalar y configurar** (el instalador y la configuración inicial necesitan la consola y la web).

| Dato | Valor |
|---|---|
| Función | Router y cortafuegos de la LAN (alternativa 2 de 3), administrado por web |
| Sistema | OPNsense 26.7 (FreeBSD) |
| Imagen | `OPNsense-26.7-dvd-amd64.iso.bz2`: SHA256 `95cafedd…186bfb` = **coincide** con `OPNsense-26.7-checksums-amd64.sha256` oficial. ISO descomprimida: `1efd5dc9…d5dcd`, igual al valor anotado el 17/11 |
| Recursos | 2 vCPU · 2 GB RAM · 20 GB VDI · BIOS |
| Red | Adaptador 1 = WAN (NAT) → `em0` · Adaptador 2 = LAN `lan-iso` → `em1` = **192.168.29.1/24** |
| Configuración VirtualBox | [config/virtualbox-showvminfo.txt](config/virtualbox-showvminfo.txt) |

## Criterios pendientes: a210 a a216 (y a105)

## Guía para completarla (≈ 40 min)

1. **Instalar:** `VBoxManage startvm r-opnsense`. Entrar como `installer` / `opnsense` → *Install (UFS)* → disco `ada0` → contraseña de root → *Complete Install*. Después, apagar y quitar la ISO:
   `VBoxManage storageattach r-opnsense --storagectl SATA --port 1 --medium emptydrive`
2. **Interfaces (consola, opción 1 y 2):** WAN = `em0` por DHCP; LAN = `em1` → `192.168.29.1/24`, DHCP .100–.200. 📸 consola con las dos IP.
3. **Solo un router a la vez:** `VBoxManage controlvm r-mikrotik setlinkstate2 off` y lo mismo con `r-nftables`.
4. **Web** desde un cliente de la LAN (`https://192.168.29.1`): asistente inicial, zona horaria `Europe/Madrid`, **System → Firmware → Updates** (a79). 📸 versión antes y después.
5. **Usuario propio (a211):** *System → Access → Users* → `mauro`, grupo `admins`. 📸
6. **Reglas (a214):** *Firewall → Rules → LAN*: Pass TCP 443 con *Log*; Block TCP 80 con *Log*; **por encima** de la regla *Default allow LAN*. Prueba desde `srv-linux` con `curl` y 📸 de *Firewall → Log Files → Live View* con las dos líneas.
7. **Copia (a215):** *System → Configuration → Backups* → descargar el XML (cifrado) → subirlo con `scp` a `c-opnsense@192.168.29.10:/mnt/copias/r-opnsense/`. Antes hay que crear el usuario `c-opnsense` en TrueNAS como los demás ([nas-truenas](../nas-truenas/README.md)).
8. **Fallo y recuperación (a216):** borrar la regla de NAT de salida o las reglas LAN → el cliente se queda sin Internet → *Backups → Restore* con el XML bajado del NAS → el cliente vuelve a tener Internet. 📸 de cada paso y anotar el tiempo.
