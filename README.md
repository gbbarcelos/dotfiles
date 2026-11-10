# dotfiles

Configurações do meu SO de Arch Linux e Hyprland para notebook, com condições específicas para economia de energia e visualização detalhada da bateria e pastas estruturadas como pacotes do [GNU Stow](https://www.gnu.org/software/stow/) para uso de symlinks.

![pré-visualização do setup](imgs/captura_de_tela(1).png)
![pré-visualização do setup](imgs/captura_de_tela(2).png)
![pré-visualização do setup](imgs/captura_de_tela(3).png)
![pré-visualização do setup](imgs/captura_de_tela(4).png)
![pré-visualização do setup](imgs/captura_de_tela(5).png)

## Instalação

### Automática

```bash
git clone https://github.com/gbbarcelos/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

O script instala os pacotes, cria os symlinks via stow e define o Zsh como shell padrão. Os passos abaixo são o que ele executa, para quem preferir rodar manualmente ou adaptar.

### 1. Instalar os pacotes

```bash
sudo pacman -S --needed \
    hyprland waybar wofi swaync kitty zsh starship neovim yazi zathura jq \
    bluez bluez-utils hyprpolkitagent wiremix \
    ttf-jetbrains-mono-nerd ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-nerd-fonts-symbols \
    grim slurp wf-recorder hyprsunset wl-clipboard
yay -S --needed wayfreeze wlogout orbit-wifi
```

### 2. Clonar o repositório

```bash
git clone https://github.com/gbbarcelos/dotfiles ~/dotfiles
cd ~/dotfiles
```

### 3. Criar os symlinks com Stow

```bash
stow -t ~ hypr kitty nvim scripts starship swaync waybar wlogout wofi yazi zathura zshrc
```

### 4. Tornar os scripts executáveis

```bash
chmod +x ~/.config/scripts/*.sh
```

### 5. Definir o Zsh como shell padrão

```bash
chsh -s $(which zsh)
```

