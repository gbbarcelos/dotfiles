if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = "1" ]; then
    exec start-hyprland
fi