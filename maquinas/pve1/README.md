# `pve1` · `pve2` · `pve3` · Clúster Proxmox VE

> **Estado: ⏳ VM creadas (con virtualización anidada) y con la ISO verificada montada. Falta instalarlas.** El clúster completo (3 × 4 GB + NAS 8 GB ≈ 20 GB) **no cabe en el equipo de casa** (16 GB, ver [T7](../../tareas/T7-rendimiento.md)): se hará en el **equipo de clase** (30 GiB), donde está el mismo disco USB.

| Dato | `pve1` | `pve2` | `pve3` |
|---|---|---|---|
| IP fija | 192.168.29.11 | 192.168.29.12 | 192.168.29.15 |
| Recursos | 2 vCPU · 4 GB · 32 GB · **UEFI** · `nested-hw-virt on` | igual | igual |
| Red | `lan-iso` (modo promiscuo «Permitir todo», necesario para el puente `vmbr0`) | igual | igual |
| Imagen | `proxmox-ve_9.2-1.iso`, SHA256 `4e88fe41…3ef2c6c` = **coincide** con `SHA256SUMS` de enterprise.proxmox.com | igual | igual |

Configuración de VirtualBox: [pve1](config/virtualbox-showvminfo.txt) · [pve2](../pve2/config/virtualbox-showvminfo.txt) · [pve3](../pve3/config/virtualbox-showvminfo.txt).

## ¿Por qué 3 nodos y no 2?

Proxmox decide por **quórum**: hace falta más de la mitad de los votos. Con 2 nodos, si cae uno queda 1 de 2, que no es mayoría, y el clúster se bloquea por seguridad para evitar el *split-brain*. Con 3, si cae uno quedan 2 de 3 y el clúster sigue funcionando.

## Criterios pendientes: a228–a232, a235, a236

## Guía (en el equipo de clase)

1. Instalar los tres nodos: *Install Proxmox VE (Graphical)* → disco ext4 → país España → contraseña de root → hostname `pve1.iso29.lan`, IP `192.168.29.11/24`, gateway y DNS `192.168.29.1`. 📸 resumen antes de instalar.
2. Quitar las ISO, arrancar y en cada nodo:

   ```bash
   pveversion                                         # a228 📸
   # Repositorio gratuito y actualización (a79)
   sed -i 's/^/#/' /etc/apt/sources.list.d/pve-enterprise.sources
   echo "deb https://download.proxmox.com/debian/pve trixie pve-no-subscription" > /etc/apt/sources.list.d/pve-no-sub.list
   apt update && apt full-upgrade -y
   ```

3. **Usuario (a229):** `pveum user add mauro@pve --password` · `pveum acl modify / --users mauro@pve --roles Administrator`.
4. **Clúster (a232):** en `pve1`, `pvecm create cluster-iso29`; en `pve2` y `pve3`, `pvecm add 192.168.29.11`. Comprobar con `pvecm status`: 3 votos y `Quorate: Yes`. 📸
5. **Migración (a235, a236):** crear un contenedor Debian (`pct create`) y una VM Debian **sin escritorio**. Migrarlos (`pct migrate 100 pve2 --restart` y `qm migrate 101 pve2 --online`) y anotar **tiempo**, **parada** y **espacio copiado** (`du -sh`) de cada uno. 📸
6. **Copias (a231):** `vzdump` del contenedor al NAS (almacenamiento NFS o SFTP hacia `copias/proxmox`) y copia de `/etc/pve`.
