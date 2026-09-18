# dotfiles

Configurações do meu SO de Arch Linux e Hyprland para notebook, com condições específicas para economia de energia e visualização detalhada da bateria e pastas estruturadas como pacotes do [GNU Stow](https://www.gnu.org/software/stow/) para uso de symlinks.
Contém, também, um arquivo para instalação automática de todas as aplicações e configurações do sistema. Para maior conveniência, especifiquei tudo abaixo, além de instruções para instalação manual. Ao final, independentemente de qual instalação for escolhida, certifique-se de trocar o caminho de algumas coisas, como dos wallpapers.

## Programas configurados

| Pasta | Programa | Descrição |
| --- | --- | --- |
| `hypr/` | [Hyprland](https://hyprland.org/) | Wayland: `hyprland.conf`, `hyprlock.conf`, `hypridle.conf`, `hyprsettings.toml` e módulos por função (`animations`, `env`, `input`, `monitor`, `windowrules`, `autostart`, `general`, `keybinds`) |
| `waybar/` | Waybar | Barra de tarefas (`config.jsonc`, `style.css`, `colors.css`) |
| `wofi/` | Wofi | Launcher de aplicativos (`config`, `style.css`) |
| `swaync/` | SwayNC | Central de notificações (`style.css`) |
| `kitty/` | Kitty | Emulador de terminal (`kitty.conf`) |
| `zshrc/` | Zsh | Shell (`.zshrc`) |
| `.zprofile/` | Zsh (login) | `.zprofile` inicia o Hyprland automaticamente sem a tela de login |
| `starship/` | Starship | Prompt do shell (`starship.toml`) |
| `nvim/` | Neovim | Editor baseado no [LazyVim](https://www.lazyvim.org/) (`lua/config/`, `lua/plugins/`) |
| `code/` | VS Code | `settings.json` |
| `yazi/` | Yazi | Gerenciador de arquivos no terminal (`yazi.toml`, `theme.toml`, `keymap.toml`, `package.toml`) |
| `zathura/` | Zathura | Visualizador de PDF (`zathurarc`) |
| `wifi-manager/` | wifi-manager | Gerenciador de Wi-Fi (`config.toml`, `style.css`) |
| `scripts/` | Scripts específicos | `screenshot.sh` (captura de tela/gravação) e `yazi_flutuante.sh` (Yazi flutuante via Hyprland) |
| `mimeapps/` | XDG MIME | `mimeapps.list` para associações padrão de aplicativo por tipo de arquivo |

## Programas essenciais do sistema (sem configuração versionada)

Estes pacotes estão instalados e são necessários para o funcionamento básico do sistema, tais como rede, som, fontes com ícones, etc., mas não têm arquivo de configuração próprio neste repositório.

| Pacote(s) | Papel | Por que é imprescindível |
| --- | --- | --- |
| `networkmanager`, `iwd` | Rede/Wi-Fi | O `wifi-manager` depende do backend de rede estar ativo |
| `pipewire`, `pipewire-pulse`, `pipewire-alsa`, `wireplumber` | Áudio | Stack de áudio do sistema |
| `bluez`, `bluez-utils` | Bluetooth | Daemon e utilitários de Bluetooth (`bluetooth.service`) |
| `polkit`, `hyprpolkitagent` | Autenticação gráfica | Sem um agente Polkit, prompts de autenticação gráfica (instalar pacotes via GUI, montar discos, etc.) falham |
| `xdg-desktop-portal`, `xdg-desktop-portal-hyprland` | Portais Wayland | Necessário para compartilhamento de tela e seletor de arquivos nativo |
| `upower` | Energia | Fornece o status de bateria usado por Waybar e outras integrações de energia |
| `ttf-jetbrains-mono-nerd`, `ttf-cascadia-code-nerd`, `ttf-cascadia-mono-nerd`, `ttf-nerd-fonts-symbols` | Fontes | Nerd Fonts usadas para os ícones da Waybar, Kitty, Wofi e Hyprlock |
| `grim`, `slurp`, `wf-recorder`, `brightnessctl`, `playerctl`, `wl-clipboard` | Dependências do `screenshot.sh` | Captura de tela e região, gravação de tela, cópia para a área de transferência, controle de brilho e mídia |
| `wayfreeze` (AUR) | Dependência do `screenshot.sh` | Congela a tela durante o print por região, sendo usado só pelas funções `screenshot_region`/`record_region` |

## Aplicativos de uso pessoal (não essenciais)

Instalados na máquina e usados no dia a dia, mas sem configuração versionada aqui e sem impacto no funcionamento do sistema em si.

| Pacote(s) | Categoria | Uso |
| --- | --- | --- |
| `firefox`, `firefox-i18n-pt-br` | Navegador | Maioral 1, com tradução para pt-BR |
| `discord` | Comunicação | Maioral 2 |
| `steam` | Jogos | Maioral 3 |
| `mpv` | Mídia | Player de vídeo e áudio |
| `dolphin` | Arquivos | Gerenciador de arquivos gráfico |
| `pavucontrol` | Áudio | Interface gráfica do volume por aplicativo |
| `blueman` | Bluetooth | Interface gráfica do bluetooth |
| `network-manager-applet` | Rede | Ícone da waybar para internet (`nm-applet`) |
| `godot-mono` | Desenvolvimento | Engine de jogos Godot (build com suporte a C#) |
| `dotnet-sdk`, `dotnet-sdk-9.0`, `aspnet-runtime` | Desenvolvimento | SDKs .NET/ASP.NET |
| `typst`, `tinymist` | Documentos | Compilador de documentos Typst |
| `htop` | Sistema | Monitor de processos no terminal |
| `imagemagick` | Imagens | Manipulação de imagens via linha de comando (importante pro Yazi!) |

> `steam` e as libs `lib32-*` (Nvidia, Vulkan) vêm do repositório `multilib`, que precisa estar habilitado em `/etc/pacman.conf` antes de instalar (`sudo sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf && sudo pacman -Sy`).

## Instalação

### Automática

```bash
git clone https://github.com/gbbarcelos/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh # só o básico
./install.sh --apps # básicão + aplicativos de uso pessoal, tipo o firefox, discord e steam
```

O script instala os pacotes, cria os symlinks via stow, define o Zsh como shell padrão e habilita o TLP. Os passos abaixo são o que ele executa, para quem preferir rodar manualmente ou adaptar.

### 1. Instalar os pacotes

```bash
sudo pacman -S --needed \
    hyprland waybar wofi swaync kitty zsh starship neovim yazi zathura jq tlp \
    networkmanager iwd pipewire pipewire-pulse pipewire-alsa wireplumber \
    bluez bluez-utils polkit hyprpolkitagent \
    xdg-desktop-portal xdg-desktop-portal-hyprland upower \
    ttf-jetbrains-mono-nerd ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-nerd-fonts-symbols \
    grim slurp wf-recorder brightnessctl playerctl wl-clipboard
yay -S --needed visual-studio-code-bin wayfreeze
sudo systemctl enable --now NetworkManager.service iwd.service bluetooth.service upower.service
```

### 2. Clonar o repositório

```bash
git clone https://github.com/gbbarcelos/dotfiles ~/dotfiles
cd ~/dotfiles
```

### 3. Criar os symlinks com Stow

```bash
stow -t ~ code hypr kitty mimeapps nvim scripts starship swaync waybar wifi-manager wofi yazi zathura zshrc .zprofile
```

### 4. Tornar os scripts executáveis

```bash
chmod +x ~/.config/scripts/*.sh
```

### 5. Definir o Zsh como shell padrão

```bash
chsh -s $(which zsh)
```

### 6. Configurar o TLP (gerenciamento de energia)

> Caso use desktop, apenas pule esta etapa.

```bash
sudo systemctl enable tlp.service
sudo systemctl start tlp.service
sudo systemctl disable systemd-rfkill.service systemd-rfkill.socket
sudo tlp start
```
