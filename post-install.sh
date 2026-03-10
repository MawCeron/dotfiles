#!/bin/bash
set -e

# ─── Helpers ──────────────────────────────────────────────────────────────────
info()    { echo -e "\n\e[38;2;104;120;160m[•]\e[0m $*"; }
success() { echo -e "\e[38;2;122;184;122m[✓]\e[0m $*"; }
warn()    { echo -e "\e[38;2;201;168;76m[!]\e[0m $*"; }

cmd_exists() { command -v "$1" &>/dev/null; }

echo ""
echo -e "\e[38;2;200;212;220mIniciando configuración post-instalación...\e[0m"

mkdir -p ~/.local/bin

# ─── [1/8] Actualización del sistema ─────────────────────────────────────────
info "[1/8] Actualización del sistema"
sudo dnf upgrade --refresh -y

# ─── [2/8] RPM Fusion ────────────────────────────────────────────────────────
info "[2/8] Instalando repositorios RPM Fusion"
FEDORA_VER=$(rpm -E %fedora)

if ! rpm -q rpmfusion-free-release &>/dev/null; then
    sudo dnf install -y \
        "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VER}.noarch.rpm"
else
    warn "RPM Fusion Free ya instalado, omitiendo"
fi

if ! rpm -q rpmfusion-nonfree-release &>/dev/null; then
    sudo dnf install -y \
        "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VER}.noarch.rpm"
else
    warn "RPM Fusion NonFree ya instalado, omitiendo"
fi

sudo dnf upgrade --refresh -y

# ─── [3/8] Codecs multimedia ──────────────────────────────────────────────────
info "[3/8] Instalando codecs multimedia"
sudo dnf install -y @multimedia
sudo dnf install -y ffmpeg "lame*" --exclude=lame-devel --allowerasing

# ─── [4/8] Herramientas básicas ───────────────────────────────────────────────
info "[4/8] Instalando herramientas básicas"
sudo dnf install -y \
    git btop p7zip fastfetch network-manager-applet NetworkManager-tui \
    blueman lsd ripgrep tmux brightnessctl zsh fzf zoxide ImageMagick pdftk bat \
    fd-find jq poppler swaylock swayidle grim slurp foot papirus-icon-theme \
    qt6-qtsvg qt6-qtvirtualkeyboard qt6-qtmultimedia python3-pip

# ─── [5/8] Utilidades Sway ────────────────────────────────────────────────────
info "[5/8] Instalando utilidades de Sway y Wayland"
sudo dnf install -y rofi mako wl-clipboard mate-polkit zenity
pip3 install autotiling --break-system-packages

# ─── [6/8] DevTools ───────────────────────────────────────────────────────────
info "[6/8] Instalando herramientas de desarrollo"
sudo dnf install -y neovim golang nodejs

# Docker
if ! cmd_exists docker; then
    if ! sudo dnf repolist | grep -q "docker-ce-stable"; then
        sudo dnf config-manager addrepo \
            --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
    else
        warn "Repo Docker ya existe, omitiendo addrepo"
    fi
    sudo dnf install -y docker-ce docker-ce-cli containerd.io \
        docker-buildx-plugin docker-compose-plugin
    sudo systemctl enable --now docker
    sudo groupadd docker 2>/dev/null || warn "Grupo docker ya existe"
    sudo usermod -aG docker "$USER"
else
    warn "Docker ya instalado, omitiendo"
fi

# ─── [7/8] Aplicaciones ───────────────────────────────────────────────────────
info "[7/8] Instalando aplicaciones generales"
sudo dnf install -y \
    firefox zathura zathura-pdf-poppler imv pavucontrol inkscape \
    fontawesome-fonts-all jetbrains-mono-fonts-all

# Yazi
if ! cmd_exists yazi; then
    TMP_YAZI=$(mktemp -d)
    wget -q -O "$TMP_YAZI/yazi.zip" \
        https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-musl.zip
    unzip -q "$TMP_YAZI/yazi.zip" -d "$TMP_YAZI"
    sudo install -m755 "$TMP_YAZI/yazi-x86_64-unknown-linux-musl/yazi" /usr/local/bin/
    sudo install -m755 "$TMP_YAZI/yazi-x86_64-unknown-linux-musl/ya"   /usr/local/bin/
    rm -rf "$TMP_YAZI"
    success "Yazi instalado"
else
    warn "Yazi ya instalado, omitiendo"
fi

# Lazygit
if ! cmd_exists lazygit; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
        | grep -Po '"tag_name": *"v\K[^"]*')
    TMP_LG=$(mktemp -d)
    curl -sLo "$TMP_LG/lazygit.tar.gz" \
        "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf "$TMP_LG/lazygit.tar.gz" -C "$TMP_LG" lazygit
    sudo install -m755 "$TMP_LG/lazygit" -D -t /usr/local/bin/
    rm -rf "$TMP_LG"
    success "Lazygit instalado"
else
    warn "Lazygit ya instalado, omitiendo"
fi

# wl-color-picker
if [ ! -f ~/.local/bin/wl-color-picker ]; then
    wget -q -O ~/.local/bin/wl-color-picker \
        https://raw.githubusercontent.com/jgmdev/wl-color-picker/main/wl-color-picker.sh
    chmod +x ~/.local/bin/wl-color-picker
    success "wl-color-picker instalado"
else
    warn "wl-color-picker ya existe, omitiendo"
fi

# Graphite GTK theme
if [ ! -d ~/.local/share/themes/Graphite-Dark ]; then
    TMP_GRAPHITE=$(mktemp -d)
    git clone --depth=1 https://github.com/vinceliuice/Graphite-gtk-theme.git "$TMP_GRAPHITE/graphite"
    cd "$TMP_GRAPHITE/graphite" && ./install.sh && cd ~
    rm -rf "$TMP_GRAPHITE"
    success "Graphite GTK theme instalado"
else
    warn "Graphite ya instalado, omitiendo"
fi

# SilentSDDM
if [ ! -d /usr/share/sddm/themes/silent ]; then
    TMP_SDDM=$(mktemp -d)
    git clone -b main --depth=1 https://github.com/uiriansan/SilentSDDM "$TMP_SDDM/SilentSDDM"
    sudo mkdir -p /usr/share/sddm/themes/silent
    sudo cp -rf "$TMP_SDDM/SilentSDDM/." /usr/share/sddm/themes/silent/
    sudo cp -r  "$TMP_SDDM/SilentSDDM/fonts/." /usr/share/fonts/
    rm -rf "$TMP_SDDM"
    success "SilentSDDM instalado"
else
    warn "SilentSDDM ya instalado, omitiendo clone"
fi

# ─── [8/8] ZSH + OhMyPosh + Dotfiles ─────────────────────────────────────────
info "[8/8] Configurando ZSH + OhMyPosh + Dotfiles"

sudo chsh -s "$(which zsh)" "$USER"

# Oh My Posh
if ! cmd_exists oh-my-posh; then
    curl -s https://ohmyposh.dev/install.sh | bash -s
    success "OhMyPosh instalado"
else
    warn "OhMyPosh ya instalado, omitiendo"
fi
oh-my-posh font install FiraCode

mkdir -p ~/.config/ohmyposh
curl -fLo ~/.config/ohmyposh/blueprint-slate.omp.json \
    https://gist.github.com/MawCeron/d01de94646575d15dca997c1ed56f3c5/raw/blueprint-slate.omp.json

# Stow dotfiles
sudo dnf install -y stow
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.bak && warn "~/.zshrc movido a ~/.zshrc.bak"

if [ ! -d ~/dotfiles ]; then
    git clone https://github.com/MawCeron/dotfiles ~/dotfiles
else
    warn "~/dotfiles ya existe, haciendo pull"
    git -C ~/dotfiles pull
fi

cd ~/dotfiles && stow . && cd ~

# Permisos de ejecución para scripts
chmod +x ~/.config/sway/scripts/*.sh    2>/dev/null || warn "No hay scripts en sway/scripts"
chmod +x ~/.config/waybar/scripts/*.sh  2>/dev/null || warn "No hay scripts en waybar/scripts"
chmod +x ~/.config/rofi/launchers/*.sh  2>/dev/null || warn "No hay scripts en rofi/launchers"
chmod +x ~/.config/rofi/powermenu/*.sh  2>/dev/null || warn "No hay scripts en rofi/powermenu"

# Apariencia GTK
gsettings set org.gnome.desktop.interface gtk-theme    'Graphite-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface icon-theme   'Papirus-Dark'

# Copiar config SDDM y wallpaper (requiere stow previo)
sudo cp ~/.config/sddm/silent/blueprint-slate.conf /usr/share/sddm/themes/silent/configs/
sudo cp ~/.config/backgrounds/001.jpg              /usr/share/sddm/themes/silent/backgrounds/
sudo sed -i 's|^ConfigFile=.*|ConfigFile=configs/blueprint-slate.conf|' \
    /usr/share/sddm/themes/silent/metadata.desktop

sudo tee /etc/sddm.conf > /dev/null << 'SDDMEOF'
[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard

[Theme]
Current=silent
SDDMEOF

# Plugins de Yazi (requiere dotfiles/package.toml)
ya pkg install
# Zinit se instala automáticamente al primer arranque de zsh via .zshrc

# cliphist
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:/usr/local/go/bin:$GOBIN"

if ! cmd_exists cliphist; then
    go install go.senan.xyz/cliphist@latest
    success "cliphist instalado"
else
    warn "cliphist ya instalado, omitiendo"
fi

# Configuración global de Git
git config --global user.name  "Mauricio Cerón"
git config --global user.email "ceron.maw@gmail.com"
git config --global core.editor nvim
git config --global init.defaultBranch main
git config --global color.ui auto
git config --global pull.rebase false

echo ""
success "Instalación completada. Reinicia la sesión para aplicar todos los cambios."