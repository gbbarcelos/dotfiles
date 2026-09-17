#!/usr/bin/env bash
set -euo pipefail

for cmd in hyprctl jq kitty yazi; do
    command -v "$cmd" &>/dev/null || { echo "Erro: '$cmd' não encontrado no PATH" >&2; exit 1; }
done

count=$(hyprctl activeworkspace -j | jq '.windows')

if [[ "$count" -eq 0 ]]; then
    hyprctl dispatch exec "[float; center; size 1200 750] kitty --title yazi yazi"
else
    hyprctl dispatch exec "kitty --title yazi yazi"
fi