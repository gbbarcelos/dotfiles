#!/usr/bin/env bash
set -euo pipefail

BOLD='\033[1m'
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'


sep() {
    printf '%b%s%b\n' "$CYAN" "────────────────────────────" "$RESET"
}

header() {
    printf '\n%b%s%b\n' "$BOLD$CYAN" "$1" "$RESET"
    sep
}

header "🌡️  TEMPERATURA"
if command -v sensors >/dev/null 2>&1; then
    sensors 2>/dev/null | grep -E "Core|Package|temp1|Tctl|Tdie" || echo "Nenhum sensor de temperatura encontrado."
else
    for zone in /sys/class/thermal/thermal_zone*/temp; do
        [ -r "$zone" ] || continue
        temp=$(( $(cat "$zone") / 1000 ))
        zone_name=$(dirname "$zone")
        type=$(cat "$zone_name/type" 2>/dev/null || echo "zona")
        printf "%s: %s°C\n" "$type" "$temp"
    done
fi

header "🔋 BATERIA"
if command -v upower >/dev/null 2>&1; then
    bat_path=$(upower -e 2>/dev/null | grep -i battery | head -1)
    if [ -n "${bat_path:-}" ]; then
        upower -i "$bat_path" | grep -E "state|percentage|time to|energy-rate" | sed 's/^[[:space:]]*//'
    else
        echo "Nenhuma bateria detectada."
    fi
else
    bat_dir=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -1)
    if [ -n "${bat_dir:-}" ]; then
        capacity=$(cat "$bat_dir/capacity" 2>/dev/null || echo "?")
        status=$(cat "$bat_dir/status" 2>/dev/null || echo "?")
        echo "Capacidade: ${capacity}%"
        echo "Status: ${status}"
    else
        echo "Nenhuma bateria detectada."
    fi
fi

header "📊 USO GERAL (CPU / MEMÓRIA / DISCO)"
read -r _ u1 n1 s1 i1 w1 _ < <(grep '^cpu ' /proc/stat)
sleep 1
read -r _ u2 n2 s2 i2 w2 _ < <(grep '^cpu ' /proc/stat)
total1=$((u1+n1+s1+i1+w1))
total2=$((u2+n2+s2+i2+w2))
idle_diff=$(( (i2+w2) - (i1+w1) ))
total_diff=$(( total2 - total1 ))
if [ "$total_diff" -gt 0 ]; then
    cpu_use=$(( 100 * (total_diff - idle_diff) / total_diff ))
    printf "CPU em uso: %s%%\n" "$cpu_use"
fi

free -h | awk 'NR==1{print "        "$1,$2,$3,$4,$6} NR==2{printf "Mem:    %s usados de %s (livre: %s, disponível: %s)\n",$3,$2,$4,$7}'
echo
df -h --output=target,size,used,avail,pcent / 2>/dev/null | tail -n +2 | awk '{printf "Disco (%s): %s usados de %s (%s livre, %s)\n", $1,$3,$2,$4,$5}'

header "⚙️  TOP 10 PROCESSOS - CPU"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 11

header "🧠 TOP 10 PROCESSOS - MEMÓRIA"
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 11

header "🕒 UPTIME E CARGA"
uptime -p 2>/dev/null || uptime
echo

printf '%b%s%b\n' "$GREEN" "Relatório gerado em $(date '+%d/%m/%Y %H:%M:%S')" "$RESET"
