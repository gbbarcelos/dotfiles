#!/usr/bin/env bash

WITH_APPS=false
[[ "${1:-}" == "--apps" ]] && WITH_APPS=true

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(hypr kitty nvim scripts starship swaync waybar wofi yazi zathura zshrc)

sudo pacman -S --needed --noconfirm \
  stow hyprland waybar wofi swaync kitty zsh starship neovim yazi zathura jq tlp \
  bluez-utils hyprpolkitagent \
  ttf-jetbrains-mono-nerd ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-nerd-fonts-symbols \
  pavucontrol blueman network-manager-applet imagemagick \
  grim slurp wf-recorder hyprsunset
yay -S --needed --noconfirm wayfreeze

cd "$DOTFILES_DIR"
stow -t "$HOME" "${PACKAGES[@]}"

chmod +x "$HOME"/.config/scripts/*.sh

if [[ "$SHELL" != *zsh ]]; then
  chsh -s "$(command -v zsh)"
fi

sudo systemctl enable --now tlp.service
sudo systemctl disable systemd-rfkill.service systemd-rfkill.socket 2>/dev/null || true

echo "==> Prontinho <3 reinicie o sistema"
