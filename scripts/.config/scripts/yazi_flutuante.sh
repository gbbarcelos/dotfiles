#!/usr/bin/env bash
set -euo pipefail

for cmd in hyprctl jq kitty yazi; do
    command -v "$cmd" &>/dev/null || { echo "Erro: '$cmd' não encontrado no PATH" >&2; exit 1; }
done

count=$(hyprctl activeworkspace -j | jq '.windows')

# Workspace vazio: abre flutuante (regra da classe yazi-float em windowrules.lua)
if [[ "$count" -eq 0 ]]; then
    exec kitty --class yazi-float --title yazi yazi
else
    exec kitty --title yazi yazi
fi
