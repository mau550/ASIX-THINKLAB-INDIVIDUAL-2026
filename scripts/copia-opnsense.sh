#!/bin/bash
# copia-opnsense.sh — Copia de la configuración de r-opnsense al NAS (nas-truenas), cifrada.
# 1) Descarga config.xml por la API REST (clave de API de solo lectura de configuración)
# 2) La cifra con AES-256 (contiene hashes de contraseñas y claves)
# 3) La sube por SFTP con clave al usuario c-opnsense del NAS (solo ve /mnt/copias/r-opnsense)
# Variables (fichero de credenciales fuera del repositorio): OPN_URL, OPN_KEY, OPN_SECRET, CLAVE_CIFRADO, SSH_KEY
# Opcionales: NAS (por defecto 192.168.29.10) y NAS_PORT (por defecto 22; p. ej. un túnel SSH desde fuera de la LAN)
set -euo pipefail
: "${OPN_URL:?}" "${OPN_KEY:?}" "${OPN_SECRET:?}" "${CLAVE_CIFRADO:?}" "${SSH_KEY:?}"
F="r-opnsense-config-$(date +%Y%m%d-%H%M).xml"; T=$(mktemp -d)
curl -sfk -u "$OPN_KEY:$OPN_SECRET" "$OPN_URL/api/core/backup/download/this" -o "$T/$F"
grep -q '<opnsense>' "$T/$F" || { echo "ERROR: la descarga no es un config.xml"; exit 1; }
openssl enc -aes-256-cbc -pbkdf2 -iter 200000 -salt -in "$T/$F" -out "$T/$F.enc" -pass env:CLAVE_CIFRADO
( cd "$T" && sha256sum "$F.enc" > "$F.enc.sha256" )
printf 'put %s\nput %s\n' "$T/$F.enc" "$T/$F.enc.sha256" | sftp -q -b - -i "$SSH_KEY" -P "${NAS_PORT:-22}" -o StrictHostKeyChecking=accept-new c-opnsense@"${NAS:-192.168.29.10}"
echo "OK: $F.enc ($(du -h "$T/$F.enc" | cut -f1)) subida a c-opnsense@nas-truenas"
rm -rf "$T"
