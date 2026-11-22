#!/bin/bash
# copia-config.sh — Copia de la configuración de un servidor Linux al NAS (nas-truenas) por SFTP.
# Instalación: /usr/local/sbin/copia-config.sh  +  /etc/copia-config.conf  +  copia-config.{service,timer}
# Configuración (/etc/copia-config.conf):
#   USUARIO_NAS=c-nftables            # usuario propio de esta máquina en TrueNAS (solo ve su carpeta)
#   NAS=192.168.29.10
#   RUTAS="etc/nftables.conf etc/network/interfaces"   # rutas relativas a /
#   EXTRA="dpkg --get-selections"     # (opcional) orden cuya salida también se guarda
set -euo pipefail
source /etc/copia-config.conf
H=$(hostname -s); FECHA=$(date +%Y%m%d-%H%M); DIR=/var/backups/copia-config
F="$DIR/$H-$FECHA.tar.gz"; TMP=$(mktemp -d)
mkdir -p "$DIR"
if [ -n "${EXTRA:-}" ]; then bash -c "$EXTRA" > "$TMP/extra-$H.txt"; fi
EXTRAS=(); [ -n "$(ls -A "$TMP")" ] && EXTRAS=(-C "$TMP" $(ls "$TMP"))
tar czf "$F" -C / $RUTAS "${EXTRAS[@]}"
( cd "$DIR" && sha256sum "$(basename "$F")" > "$(basename "$F").sha256" )
sftp -q -i /root/.ssh/copia_nas -o StrictHostKeyChecking=accept-new -o BatchMode=yes -b - "$USUARIO_NAS@$NAS" <<SFTP
put $F
put $F.sha256
SFTP
ls -1t "$DIR"/"$H"-*.tar.gz | tail -n +8 | while read -r v; do rm -f "$v" "$v.sha256"; done   # 7 copias locales
rm -rf "$TMP"
logger -t copia-config "OK: $(basename "$F") ($(du -h "$F" | cut -f1)) subida a $USUARIO_NAS@$NAS"
echo "OK: $(basename "$F") subida a $USUARIO_NAS@$NAS"
