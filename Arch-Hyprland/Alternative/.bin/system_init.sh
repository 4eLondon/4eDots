#!/bin/bash

echo ""
echo "========================================================"
echo "           Arch Linux System Installer                  "
echo "========================================================"
echo ""

# = = = = = Helpers = = = = =
ask() {
    echo "$1 (y/n)"
    read ans
    [ "$ans" = "y" ] || [ "$ans" = "Y" ]
}

install() {
    echo "Installing $1..."
    sudo pacman -S --noconfirm --needed "$1"
}

aur_install() {
    echo "Installing $1 from AUR..."
    $AUR_CMD -S --noconfirm "$1"
}

pac_group() {
    echo "Installing group $1..."
    sudo pacman -S --noconfirm --needed "$1"
}

# = = = = = AUR Helper = = = = =
AUR_CMD=""

if command -v yay &>/dev/null; then
    AUR_CMD="yay"
elif command -v paru &>/dev/null; then
    AUR_CMD="paru"
else
    echo "No AUR helper found."
    echo "Install yay[1] paru[2] or skip[3]?"
    read aur_choice

    case "$aur_choice" in
        1)
            echo "Installing yay..."
            sudo pacman -S --noconfirm --needed git base-devel
            git clone https://aur.archlinux.org/yay.git /tmp/yay
            cd /tmp/yay && makepkg -si --noconfirm
            cd - > /dev/null
            AUR_CMD="yay"
            ;;
        2)
            echo "Installing paru..."
            sudo pacman -S --noconfirm --needed git base-devel
            git clone https://aur.archlinux.org/paru.git /tmp/paru
            cd /tmp/paru && makepkg -si --noconfirm
            cd - > /dev/null
            AUR_CMD="paru"
            ;;
        *)
            echo "Skipping AUR helper."
            ;;
    esac
fi

# = = = = = Section Functions = = = = =

install_wm() {
    echo ""
    echo "========================================================"
    echo "                   Window Manager                       "
    echo "========================================================"
    echo ""
    echo "Which window manager would you like to install?"
    echo "Hyprland[1] i3[2] Sway[3] bspwm[4] dwm[5] GNOME[6] KDE[7] skip[8]"
    read wm_choice

    case "$wm_choice" in
        1)
            echo "Installing Hyprland and dependencies..."
            sudo pacman -S --noconfirm --needed \
                hyprland \
                xdg-desktop-portal-hyprland \
                waybar \
                wofi \
                dunst \
                hyprpaper \
                hyprlock \
                hypridle \
                pipewire \
                pipewire-pulse \
                pipewire-alsa \
                wireplumber \
                polkit-gnome \
                qt5-wayland \
                qt6-wayland \
                wl-clipboard \
                grim \
                slurp \
                cliphist
            if [ -n "$AUR_CMD" ]; then
                aur_install hyprshot
            fi
            ;;
        2)
            echo "Installing i3 and dependencies..."
            sudo pacman -S --noconfirm --needed \
                i3-wm \
                i3status \
                i3lock \
                i3blocks \
                dmenu \
                picom \
                feh \
                dunst \
                xorg \
                xorg-xinit \
                xclip \
                arandr \
                autorandr \
                pipewire \
                pipewire-pulse \
                wireplumber \
                polkit-gnome
            ;;
        3)
            echo "Installing Sway and dependencies..."
            sudo pacman -S --noconfirm --needed \
                sway \
                swaylock \
                swayidle \
                wofi \
                dunst \
                waybar \
                pipewire \
                pipewire-pulse \
                wireplumber \
                wl-clipboard \
                grim \
                slurp \
                polkit-gnome \
                qt5-wayland \
                qt6-wayland
            ;;
        4)
            echo "Installing bspwm and dependencies..."
            sudo pacman -S --noconfirm --needed \
                bspwm \
                sxhkd \
                picom \
                polybar \
                dmenu \
                feh \
                dunst \
                xorg \
                xorg-xinit \
                xclip \
                arandr \
                pipewire \
                pipewire-pulse \
                wireplumber \
                polkit-gnome
            ;;
        5)
            echo "Installing dwm dependencies..."
            sudo pacman -S --noconfirm --needed \
                base-devel \
                libx11 \
                libxft \
                libxinerama \
                xorg \
                xorg-xinit \
                picom \
                feh \
                dunst \
                xclip \
                pipewire \
                pipewire-pulse \
                wireplumber
            echo ""
            echo "dwm must be compiled from source."
            echo "Clone from https://suckless.org or your own fork and run: make && sudo make install"
            ;;
        6)
            echo "Installing GNOME..."
            pac_group gnome
            sudo systemctl enable gdm
            ;;
        7)
            echo "Installing KDE Plasma..."
            pac_group plasma
            pac_group kde-applications
            sudo systemctl enable sddm
            ;;
        8)
            echo "Skipping window manager install."
            ;;
        *)
            echo "Invalid option, skipping window manager install."
            ;;
    esac
}

install_core() {
    echo ""
    echo "========================================================"
    echo "                   Core Packages                        "
    echo "========================================================"
    echo ""

    if ask "Install brightness control?"; then
        install brightnessctl
    fi

    if ask "Install audio control?"; then
        sudo pacman -S --noconfirm --needed pavucontrol pipewire pipewire-pulse wireplumber
    fi

    if ask "Install bluetooth support?"; then
        sudo pacman -S --noconfirm --needed bluez bluez-utils blueman
        sudo systemctl enable --now bluetooth
    fi

    if ask "Install network manager?"; then
        sudo pacman -S --noconfirm --needed networkmanager network-manager-applet
        sudo systemctl enable --now NetworkManager
    fi

    if ask "Install display manager?"; then
        install sddm
        sudo systemctl enable sddm
    fi

    if ask "Install notification daemon?"; then
        install dunst
    fi

    if ask "Install screenshot tools?"; then
        sudo pacman -S --noconfirm --needed grim slurp scrot
    fi

    if ask "Install clipboard manager?"; then
        sudo pacman -S --noconfirm --needed cliphist wl-clipboard xclip
    fi

    if ask "Install file manager?"; then
        sudo pacman -S --noconfirm --needed thunar thunar-volman gvfs
    fi

    if ask "Install fonts?"; then
        sudo pacman -S --noconfirm --needed \
            ttf-jetbrains-mono-nerd \
            ttf-nerd-fonts-symbols \
            noto-fonts \
            noto-fonts-emoji \
            ttf-liberation
    fi

    if ask "Install theme/icon support? (gtk + qt)"; then
        sudo pacman -S --noconfirm --needed \
            gtk3 \
            gtk4 \
            qt5ct \
            qt6ct \
            lxappearance
        if [ -n "$AUR_CMD" ]; then
            aur_install catppuccin-gtk-theme-mocha
            aur_install papirus-icon-theme
        fi
    fi

    if ask "Install polkit agent?"; then
        install polkit-gnome
    fi

    if ask "Install keyring support?"; then
        sudo pacman -S --noconfirm --needed gnome-keyring libsecret
    fi

    if ask "Install archive tools? (zip unzip tar p7zip)"; then
        sudo pacman -S --noconfirm --needed zip unzip tar p7zip unrar
    fi

    if ask "Install system monitoring? (btop)"; then
        install btop
    fi

    if ask "Install printing support?"; then
        sudo pacman -S --noconfirm --needed cups cups-pdf
        sudo systemctl enable --now cups
    fi
}

install_gui() {
    echo ""
    echo "========================================================"
    echo "                    GUI Applications                    "
    echo "========================================================"
    echo ""

    echo "--- Productivity ---"

    if ask "Install LibreOffice?"; then
        install libreoffice-fresh
    fi

    if ask "Install Obsidian?"; then
        if [ -n "$AUR_CMD" ]; then
            aur_install obsidian
        else
            echo "Obsidian requires an AUR helper, skipping."
        fi
    fi

    if ask "Install Thunderbird?"; then
        install thunderbird
    fi

    if ask "Install Zathura?"; then
        sudo pacman -S --noconfirm --needed zathura zathura-pdf-mupdf
    fi

    if ask "Install Evince?"; then
        install evince
    fi

    echo ""
    echo "--- Browsers ---"

    if ask "Install Firefox?"; then
        install firefox
    fi

    if ask "Install Chromium?"; then
        install chromium
    fi

    if ask "Install Brave?"; then
        if [ -n "$AUR_CMD" ]; then
            aur_install brave-bin
        else
            echo "Brave requires an AUR helper, skipping."
        fi
    fi

    echo ""
    echo "--- Media ---"

    if ask "Install mpv?"; then
        install mpv
    fi

    if ask "Install GIMP?"; then
        install gimp
    fi

    if ask "Install Inkscape?"; then
        install inkscape
    fi

    if ask "Install OBS Studio?"; then
        install obs-studio
    fi

    echo ""
    echo "--- Communication ---"

    if ask "Install Discord?"; then
        install discord
    fi

    if ask "Install Signal?"; then
        if [ -n "$AUR_CMD" ]; then
            aur_install signal-desktop
        else
            echo "Signal requires an AUR helper, skipping."
        fi
    fi

    echo ""
    echo "--- Development ---"

    if ask "Install VSCode?"; then
        if [ -n "$AUR_CMD" ]; then
            aur_install visual-studio-code-bin
        else
            echo "VSCode requires an AUR helper, skipping."
        fi
    fi

    if ask "Install DBeaver?"; then
        install dbeaver
    fi

    if ask "Install VirtualBox?"; then
        sudo pacman -S --noconfirm --needed virtualbox virtualbox-host-modules-arch
        sudo usermod -aG vboxusers "$USER"
        echo "VirtualBox installed. Log out and back in for group changes to apply."
    fi
}

install_terminal() {
    echo ""
    echo "========================================================"
    echo "                     Terminal                           "
    echo "========================================================"
    echo ""
    echo "Which terminal would you like to install?"
    echo "kitty[1] alacritty[2] wezterm[3] ghostty[4] skip[5]"
    read term_choice

    case "$term_choice" in
        1) install kitty ;;
        2) install alacritty ;;
        3)
            if [ -n "$AUR_CMD" ]; then
                aur_install wezterm
            else
                echo "Wezterm requires an AUR helper, skipping."
            fi
            ;;
        4)
            if [ -n "$AUR_CMD" ]; then
                aur_install ghostty
            else
                echo "Ghostty requires an AUR helper, skipping."
            fi
            ;;
        5) echo "Skipping terminal install." ;;
        *) echo "Invalid option, skipping terminal install." ;;
    esac

    echo ""
    echo "========================================================"
    echo "                   Terminal Tools                       "
    echo "========================================================"
    echo ""

    if ask "Install git?"; then
        install git
    fi

    if ask "Install neovim?"; then
        install neovim
    fi

    if ask "Install zoxide?"; then
        install zoxide
    fi

    if ask "Install yazi?"; then
        install yazi
    fi

    if ask "Install fzf?"; then
        install fzf
    fi

    if ask "Install eza?"; then
        install eza
    fi

    if ask "Install ripgrep?"; then
        install ripgrep
    fi

    if ask "Install fd?"; then
        install fd
    fi

    if ask "Install entr?"; then
        install entr
    fi

    if ask "Install tmux?"; then
        install tmux
    fi

    if ask "Install btop?"; then
        install btop
    fi

    if ask "Install docker?"; then
        install docker
        sudo systemctl enable --now docker
        sudo usermod -aG docker "$USER"
        echo "Docker installed. Log out and back in for group changes to apply."
    fi

    if ask "Install python?"; then
        sudo pacman -S --noconfirm --needed python python-pip
    fi

    if ask "Install openssh?"; then
        install openssh
        sudo systemctl enable --now sshd
    fi
}

# = = = = = Main Menu = = = = =

done_installing=false

while [ "$done_installing" = false ]; do
    echo ""
    echo "========================================================"
    echo "                    What to set up?                     "
    echo "========================================================"
    echo ""
    echo "  [1] Window Manager"
    echo "  [2] Core Packages"
    echo "  [3] GUI Applications"
    echo "  [4] Terminal & Terminal Tools"
    echo "  [5] Done"
    echo ""
    echo "Select an option:"
    read section

    case "$section" in
        1) install_wm ;;
        2) install_core ;;
        3) install_gui ;;
        4) install_terminal ;;
        5) done_installing=true ;;
        *) echo "Invalid option, please enter 1-5." ;;
    esac
done

# = = = = = Done = = = = =
echo ""
echo "========================================================"
echo "              Installation Complete                     "
echo "========================================================"
echo ""

if ask "Would you like to reboot now?"; then
    echo "Rebooting..."
    sudo reboot
else
    echo "Reboot skipped. Some changes may not take effect until you reboot."
fi
