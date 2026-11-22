#!/bin/bash
# Pruebas de hardware del equipo anfitrión (Tasca 2, ampliación Apte+).
# Uso: ./pruebas-hardware.sh [disco|memoria|cpu|red|todo] [carpeta_salida]
# Requiere: fio, stress-ng, lm-sensors, curl, iputils (tracepath). Apagar las VM antes.
set -u
QUE="${1:-todo}"; OUT="${2:-.}"; F="$HOME/fio-test.tmp"; HOY=$(date +%Y%m%d)
export LC_ALL=C

disco() {
  echo "# fio en $(df --output=source "$HOME" | tail -1) — $(date -Is)"
  lsusb -t | grep -i 'Mass Storage'
  for t in "seq-write write 1M" "seq-read read 1M" "rand-read randread 4k" "rand-write randwrite 4k"; do
    set -- $t; echo; echo "\$ fio --name=$1 --rw=$2 --bs=$3 --size=1G --direct=1 --iodepth=16"
    fio --name=$1 --filename="$F" --size=1G --rw=$2 --bs=$3 --direct=1 --ioengine=libaio \
        --iodepth=16 --runtime=30 $([ "${2#rand}" != "$2" ] && echo --time_based) --group_reporting \
        | grep -E 'IOPS=|clat \((u|m)sec\): min'
  done
  rm -f "$F"
}
memoria() {
  echo "# Memoria — $(date -Is)"; free -h
  stress-ng --vm 2 --vm-bytes 3G --vm-method all --verify -t 60s --metrics-brief 2>&1 | grep -E 'passed|failed|vm '
  stress-ng --memrate 1 --memrate-bytes 512M -t 20s --metrics 2>&1 | grep -E 'write64stoq|memset'
}
cpu() {
  echo "# CPU — $(date -Is)"; sensors coretemp-isa-0000 | grep Package
  stress-ng --cpu "$(nproc)" --cpu-method matrixprod -t 60s --metrics-brief 2>&1 | tail -3 &
  sleep 50; sensors coretemp-isa-0000 | grep Package
  awk '/MHz/{s+=$4;n++} END{printf "Frecuencia media bajo carga: %.0f MHz\n",s/n}' /proc/cpuinfo; wait
}
red() {
  GW=$(ip route | awk '/default/{print $3; exit}')
  echo "# Red — $(date -Is) — puerta de enlace $GW"
  ping -c 20 -i 0.2 "$GW" | tail -2; ping -c 20 -i 0.2 1.1.1.1 | tail -2
  tracepath -n 1.1.1.1 | head -12
  U=$(curl -s https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/ | grep -o 'debian-[0-9.]*-amd64-netinst.iso' | head -1)
  curl -sL -o /dev/null --max-time 20 -w 'descarga: %{size_download} B en %{time_total} s = %{speed_download} B/s\n' \
       "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/$U"
}

case "$QUE" in
  disco|memoria|cpu|red) $QUE | tee "$OUT/$(hostname)-$QUE-$HOY.txt" ;;
  todo) for p in disco memoria cpu red; do $p | tee "$OUT/$(hostname)-$p-$HOY.txt"; done ;;
  *) echo "Uso: $0 [disco|memoria|cpu|red|todo] [carpeta]"; exit 1 ;;
esac
