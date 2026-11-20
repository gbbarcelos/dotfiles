#!/usr/bin/env bash

WITH_APPS=false
[[ "${1:-}" == "--apps" ]] && WITH_APPS=true

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(applications dolphin hypr kitty nvim numbr qt6ct scripts shotdock starship swaync waybar wlogout wofi xkb yazi zathura zshrc)

sudo pacman -S --needed --noconfirm \
  stow hyprland waybar wofi swaync kitty zsh starship neovim yazi zathura jq ttf-jetbrains-mono \
  bluez-utils hyprpolkitagent \
  ttf-jetbrains-mono-nerd ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-nerd-fonts-symbols \
  pavucontrol wiremix blueman imagemagick \
  grim slurp wf-recorder hyprsunset \
  dolphin papirus-icon-theme
yay -S --needed --noconfirm wayfreeze wlogout orbit-wifi qt6ct-kde darkly

cd "$DOTFILES_DIR"
stow -t "$HOME" "${PACKAGES[@]}"

chmod +x "$HOME"/.config/scripts/*.sh

if [[ "$SHELL" != *zsh ]]; then
  chsh -s "$(command -v zsh)"
fi

echo "==> Prontinho <3 reinicie o sistema"
