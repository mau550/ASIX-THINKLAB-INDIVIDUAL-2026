#!/bin/bash
# Uso: medir.sh <etiqueta> <segundos> <fichero>
export LC_ALL=C
ET="$1"; T="$2"; OUT="$3"; N=$((T/5))
{
echo "# Escenario: $ET — $(date -Is) — duración ${T}s (muestras cada 5 s)"
echo "## VMs en ejecución"; VBoxManage list runningvms
echo "## free -m (inicio)"; free -m
vmstat -w 5 $N > /tmp/.vm.$$ & iostat -dxm sda 5 $N > /tmp/.io.$$ & sar -n DEV 5 $N > /tmp/.net.$$ 2>/dev/null &
pidstat -u -r -C VBoxHeadless 5 $N > /tmp/.pid.$$ &
wait
echo "## vmstat -w 5"; cat /tmp/.vm.$$
echo "## iostat -dxm sda 5 (resumen)"; grep '^sda' /tmp/.io.$$ | awk '{r+=$3; w+=$9; u+=$NF; n++} END {printf "media lectura=%.1f MB/s  escritura=%.1f MB/s  %%util=%.1f  (n=%d)\n", r/n, w/n, u/n, n}'
grep '^sda' /tmp/.io.$$ | awk '{print "  %util="$NF"  r_await="$6"  w_await="$12}'
echo "## sar -n DEV (enp3s0, media)"; grep -E 'Average.*enp3s0' /tmp/.net.$$
echo "## pidstat VBoxHeadless (media)"; grep -E '^Average' /tmp/.pid.$$
echo "## free -m (fin)"; free -m
echo "## temperatura"; sensors coretemp-isa-0000 | grep Package
} > "$OUT" 2>&1
rm -f /tmp/.vm.$$ /tmp/.io.$$ /tmp/.net.$$ /tmp/.pid.$$
