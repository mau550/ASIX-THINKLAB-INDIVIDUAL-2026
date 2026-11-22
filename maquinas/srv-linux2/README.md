# `srv-linux2` · Segundo servidor Debian · espejo DRBD con `srv-linux`

| Dato | Valor |
|---|---|
| Función | Nodo secundario del **espejo de discos entre dos equipos** (T6, ampliación Apte+) |
| Origen | Clon de `srv-linux` (`VBoxManage clonevm`) con **identidad propia** (ver §1) |
| Sistema | Debian 13.8 sin escritorio · 1 vCPU · 1 GB · 10 GB + **disco de 1 GB para DRBD** |
| Red | `lan-iso`, IP fija **192.168.29.16/24** |
| Configuración | [espejo.res](config/espejo.res) · [VirtualBox](config/virtualbox-showvminfo.txt) |

## 1. Clonar sin duplicar la identidad

Un clon es idéntico al original. En la misma red eso provoca conflictos: misma IP, mismo nombre, mismo `machine-id` (DHCP y systemd lo usan como identificador) y mismas claves SSH de host (el cliente no puede distinguirlos). Con el **cable de red desconectado** (`--cableconnected1 off`) se cambió:

```bash
hostnamectl set-hostname srv-linux2; sed -i 's/srv-linux/srv-linux2/g' /etc/hosts
sed -i 's/192.168.29.14/192.168.29.16/' /etc/network/interfaces
rm /etc/machine-id; systemd-machine-id-setup                       # nuevo machine-id
rm /etc/ssh/ssh_host_*; dpkg-reconfigure openssh-server            # nuevas claves de host
sed -i '/raid[015]/d' /etc/fstab; sed -i '/^ARRAY/d' /etc/mdadm/mdadm.conf   # sin los RAID del original
```

Comprobado: `machine-id` `a46468d9…` (srv-linux) frente a `f0ea08a3…` (srv-linux2), y huellas SSH distintas. Además se quitaron del clon los discos RAID copiados.

## 2. Espejo DRBD (a108, a109)

| Paso | Resultado |
|---|---|
| `drbdadm create-md` + `up` en los dos nodos | `cs:Connected ro:Secondary/Secondary ds:Inconsistent/Inconsistent` |
| `drbdadm primary --force espejo` en srv-linux | Sincronización inicial de 1 GB en **55 s** → `UpToDate/UpToDate` |
| `mkfs.ext4 /dev/drbd0`, montado en `/srv/espejo` y 50 MB de «facturas» + SHA256 | [srv-09](../srv-linux/capturas/srv-09-espejo-drbd-primario-con-datos.png) |
| **Caída**: `VBoxManage controlvm srv-linux poweroff` (corte de luz simulado) | srv-linux2 pasa a `WFConnection ro:Primary/Unknown` |
| **Relevo**: `drbdadm primary espejo; mount /dev/drbd0 /srv/espejo` en srv-linux2 | **3,5 s** · `sha256sum -c` → **La suma coincide** ([srv2-01](capturas/srv2-01-relevo-datos-intactos.png)) |
| Se sigue trabajando: nueva factura creada en srv-linux2 | `factura-durante-la-caida.txt` |
| **Vuelve srv-linux**: `drbdadm up espejo` → entra como secundario y recibe los cambios (*resync*) | Se devuelve el rol de primario; la factura nueva **está en srv-linux** ([srv-10](../srv-linux/capturas/srv-10-espejo-vuelve-y-recibe-cambios.png)) |
| Estado final | `cs:Connected ro:Primary/Secondary ds:UpToDate/UpToDate` · `drbd.service` habilitado en los dos |

Salidas completas: [creación](../srv-linux/salidas/08-espejo-drbd-creacion.txt) · [caída y relevo](salidas/01-espejo-caida-y-relevo.txt).

**Caso de uso:** el servidor de ficheros de *Administración*. Si se estropea la fuente o la placa del servidor principal, el secundario tiene **exactamente los mismos datos** (protocolo C, síncrono: una escritura no termina hasta que está en los dos) y en segundos sirve los ficheros. Un RAID 1 en un único equipo no protegería de eso.

**Límite:** la conmutación es manual. En producción se automatizaría con Pacemaker y Corosync, con una IP flotante.
