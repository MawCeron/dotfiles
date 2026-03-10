#!/bin/bash
set -e

echo ""
echo "Iniciando la configuración post-instalación..."

# Verificar que ~/.local/bin existe
mkdir -p ~/.local/bin

# 1. Actualizar el sistema
echo -e "\n[1/8] Actualización del sistema"
sudo dnf upgrade --refresh -y

# 2. Instalar repositorios RPM Fusion (Free y Non-Free)
echo -e "\n[2/8] Instalando repositorios RPM Fusion"
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf upgrade --refresh -y

# 3. Instalar codecs multimedia
echo -e "\n[3/8] Instalando codecs multimedia de audio y video..."
sudo dnf install -y @multimedia
sudo dnf install -y ffmpeg lame\* --exclude=lame-devel --allowerasing

# 4. Utilidades y aplicaciones comunes
echo -e "\n[4/8] Instalando herramientas básicas..."
sudo dnf install -y git btop p7zip fastfetch network-manager-applet NetworkManager-tui \
    blueman lsd ripgrep tmux brightnessctl zsh fzf zoxide ImageMagick pdftk bat \
    fd-find jq poppler swaylock swayidle grim slurp foot papirus-icon-theme \
    qt6-qtsvg qt6-qtvirtualkeyboard qt6-qtmultimedia python3-pip

# 5. Dependencias de Sway
echo -e "\n[5/8] Instalando utilidades de Sway y Wayland..."
sudo dnf install -y rofi mako wl-clipboard mate-polkit zenity
pip3 install autotiling --break-system-packages

# 6. Instalación DevTools
echo -e "\n[6/8] Instalando herramientas de desarrollo..."
sudo dnf install -y neovim golang nodejs

# Instalación de Docker
sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo groupadd docker || true
sudo usermod -aG docker $USER

# 7. Instalación de aplicaciones
echo -e "\n[7/8] Instalando aplicaciones generales..."
sudo dnf install -y firefox zathura zathura-pdf-poppler imv pavucontrol inkscape \
    fontawesome-fonts-all jetbrains-mono-fonts-all

# Instalación de Yazi desde el binario oficial
wget https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-musl.zip
unzip yazi-x86_64-unknown-linux-musl.zip
cd yazi-x86_64-unknown-linux-musl/
sudo install -m755 yazi /usr/local/bin/
sudo install -m755 ya /usr/local/bin/
cd ~
rm -rf yazi-x86_64-unknown-linux-musl/
rm -f yazi-x86_64-unknown-linux-musl.zip

# Plugins de Yazi (se instalan via package.toml en dotfiles)
ya pkg install

# Instalación de Lazygit desde el binario oficial
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install -m755 lazygit -D -t /usr/local/bin/
rm -f lazygit.tar.gz lazygit

# Instalación de wl-color-picker
wget -O ~/.local/bin/wl-color-picker https://raw.githubusercontent.com/jgmdev/wl-color-picker/main/wl-color-picker.sh
chmod +x ~/.local/bin/wl-color-picker

# Instalación de temas rofi (adi1090x)
git clone --depth=1 https://github.com/adi1090x/rofi.git
cd rofi
chmod +x setup.sh
./setup.sh
cd ~
rm -rf rofi

# Color scheme Blueprint Slate para rofi
mkdir -p ~/.config/rofi/colors
cat > ~/.config/rofi/colors/blueprint-slate.rasi << 'EOF'
* {
    background:     #1c2127FF;
    background-alt: #292c32FF;
    foreground:     #c8d4dcFF;
    selected:       #6878a0FF;
    active:         #7ab87aFF;
    urgent:         #c96a6aFF;
    border:         #3d444dFF;
}
EOF

# Instalación de SilentSDDM
git clone -b main --depth=1 https://github.com/uiriansan/SilentSDDM
cd SilentSDDM
sudo mkdir -p /usr/share/sddm/themes/silent
sudo cp -rf . /usr/share/sddm/themes/silent/
sudo cp -r fonts/* /usr/share/fonts/
cd ~
rm -rf SilentSDDM

# Aplicar tema de íconos Papirus-Dark
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'

# 8. Configuración ZSH + Zinit + Oh My Posh
echo -e "\n[8/8] Configurando ZSH + Zinit + Oh My Posh..."
sudo chsh -s $(which zsh) $USER

# Oh My Posh
curl -s https://ohmyposh.dev/install.sh | bash -s
oh-my-posh font install FiraCode
mkdir -p ~/.config/ohmyposh
curl -fLo ~/.config/ohmyposh/blueprint-slate.omp.json \
    https://gist.github.com/MawCeron/d01de94646575d15dca997c1ed56f3c5/raw/blueprint-slate.omp.json

# Instalar stow y aplicar dotfiles
sudo dnf install -y stow
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.bak
git clone https://github.com/MawCeron/dotfiles ~/dotfiles
cd ~/dotfiles && stow . && cd ~

# Permisos de ejecución para scripts
chmod +x ~/.config/sway/scripts/*.sh
chmod +x ~/.config/waybar/scripts/*.sh
chmod +x ~/.config/rofi/launchers/*.sh
chmod +x ~/.config/rofi/powermenu/*.sh
# Zinit se instala automáticamente al primer arranque de zsh via .zshrc

# Copiar config Blueprint Slate y wallpaper al tema SDDM (requiere stow previo)
sudo cp ~/.config/sddm/silent/blueprint-slate.conf /usr/share/sddm/themes/silent/configs/
sudo cp ~/.config/backgrounds/001.jpg /usr/share/sddm/themes/silent/backgrounds/

# Apuntar metadata.desktop al config Blueprint Slate
sudo sed -i 's|^ConfigFile=.*|ConfigFile=configs/blueprint-slate.conf|' /usr/share/sddm/themes/silent/metadata.desktop

# Configurar /etc/sddm.conf
sudo tee /etc/sddm.conf > /dev/null << 'SDDMEOF'
[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard

[Theme]
Current=silent
SDDMEOF

sudo systemctl enable sddm

# Logo ASCII para fastfetch (se incluye en dotfiles)
mkdir -p ~/.config/fastfetch

# Instalación de cliphist (requiere Go, que ya está instalado)
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:/usr/local/go/bin:$GOBIN"
go install go.senan.xyz/cliphist@latest

# Configuración global de Git
git config --global user.name "Mauricio Cerón"
git config --global user.email "ceron.maw@gmail.com"
git config --global core.editor nvim
git config --global init.defaultBranch main
git config --global color.ui auto
git config --global pull.rebase false

echo ""
echo "✓ Instalación completada."
echo "  Reinicia la sesión para aplicar todos los cambios."