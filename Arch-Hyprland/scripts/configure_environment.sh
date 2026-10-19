#!/bin/bash
set -euo pipefail
REPO_DIR="$(pwd)"

echo -e "\n+ + [ Now configuring desktop environment ] + + \n"

mkdir -p  ~/.config/{hypr,foot,waybar,dunst}

echo -e " - ( Installing core services and tools )  - \n"
sudo pacman -S --needed --noconfirm ly brightnessctl playerctl tlp libnotify uwsm hyprland ufw polkit-gnome

sudo systemctl enable ly.service
sudo systemctl enable tlp.service
sudo systemctl enable ufw

echo -e " - ( Installing core hyprland features )  - \n"
sudo  pacman -S --needed --noconfirm hyprpaper hypridle hyprlock firefox wofi

echo -e " - ( Installing secondary desktop features )  - \n"
sudo  pacman -S --needed --noconfirm waybar foot dunst wl-clipboard grim slurp unzip 7zip zip unrar hyprpicker 

echo " - ( Copying repo config folders into ~/.config ) - "

mkdir -p ~/.config

cp -rv "$REPO_DIR/Minimal/.config/hypr"    ~/.config/hypr
cp -rv "$REPO_DIR/Minimal/.config/waybar"  ~/.config/waybar
cp -rv "$REPO_DIR/Minimal/.config/dunst"   ~/.config/dunst

echo -e "\n+ + [ Done ] + + \n"
echo "\n+ + [ Desktop environment configured ] + +\n"

