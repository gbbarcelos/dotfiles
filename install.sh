#set -euo pipefail

WITH_APPS=false
[[ "${1:-}" == "--apps" ]] && WITH_APPS=true

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(code hypr kitty mimeapps nvim scripts starship swaync waybar wifi-manager wofi yazi zathura zshrc .zprofile)

echo "==> Instalando pacotes básicos"
sudo pacman -S --needed --noconfirm \
    stow hyprland waybar wofi swaync kitty zsh starship neovim yazi zathura jq tlp \
    networkmanager iwd pipewire pipewire-pulse pipewire-alsa wireplumber \
    bluez bluez-utils polkit hyprpolkitagent \
    xdg-desktop-portal xdg-desktop-portal-hyprland upower \
    linux-firmware "$UCODE" \
    ttf-jetbrains-mono-nerd ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-nerd-fonts-symbols \
    grim slurp wf-recorder brightnessctl playerctl wl-clipboard

echo "==> Habilitando serviços essenciais, como rede, bluetooth e energia"
sudo systemctl enable --now NetworkManager.service iwd.service bluetooth.service upower.service

if command -v yay &>/dev/null; then
    echo "==> Instalando pacotes que são pelo AUR"
    yay -S --needed --noconfirm visual-studio-code-bin wayfreeze
else
    echo "!! yay não encontrado — instale manualmente: visual-studio-code-bin, wayfreeze"
fi

if $WITH_APPS; then
    echo "==> Habilitando repositório multilib (necessário para Steam)"
    if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
        sudo sed -i '/^#\[multilib\]/,/^#Include/s/^#//' /etc/pacman.conf
        sudo pacman -Sy
    fi

    echo "==> Instalando aplicativos de uso pessoal"
    sudo pacman -S --needed --noconfirm \
        firefox firefox-i18n-pt-br discord steam mpv dolphin pavucontrol \
        blueman network-manager-applet godot-mono \
        dotnet-sdk dotnet-sdk-9.0 aspnet-runtime typst tinymist \
        htop imagemagick
fi

echo "==> Criando symlinks com stow"
cd "$DOTFILES_DIR"
stow -t "$HOME" "${PACKAGES[@]}"

echo "==> Tornando os scripts executáveis"
chmod +x "$HOME"/.config/scripts/*.sh

echo "==> Definindo o Zsh como shell padrão"
if [[ "$SHELL" != *zsh ]]; then
    chsh -s "$(command -v zsh)"
fi

echo "==> Habilitando TLP"
sudo systemctl enable --now tlp.service
sudo systemctl disable systemd-rfkill.service systemd-rfkill.socket 2>/dev/null || true

echo "==> Prontinho <3 reinicie o sistema"
