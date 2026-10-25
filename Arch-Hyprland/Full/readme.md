<div align="center">

# ✦ 4eArch-Hyprland-Full ✦

![Arch Linux](https://img.shields.io/badge/ARCH_LINUX-1793D1?style=for-the-badge&logo=archlinux&logoColor=white)
![Hyprland](https://img.shields.io/badge/HYPRLAND-33CCFF?style=for-the-badge&logo=hyprland&logoColor=white)

### Minimal Edition

*A clean, keyboard-driven Hyprland setup on Arch Linux.*

</div>

---

## Overview

My personal Arch Linux + Hyprland dotfiles. The goal is a lightweight, fast and cohesive desktop with sensible defaults, a few themes to switch between, and everything kept in plain-text config files that are easy to read and tweak.

## Themes

| Snow Caution | Hazard Watch | Deep Forest | Ocean Zero |
| :----------: | :----------: | :---------: | :--------: |
| Light, high-contrast | Warning-sign yellow accents | Dark greens | Cool blues |

## What's Included

| Component | Purpose |
| :-------- | :------ |
| **Hyprland** | Window manager (animations, inputs, keybinds, monitors, startup, window rules, theme, hypridle) |
| **Waybar** | Status bar |
| **Noctalia** | Shell widgets and plugins (hyprland-keybinds, keybind-cheatsheet, screen-recorder) |
| **Wofi** | App launcher |
| **Kitty** | Terminal emulator |
| **Fish** | Interactive shell |
| **Starship** | Shell prompt |
| **Fastfetch** | System info, with custom logos |
| **Btop** | System monitor |
| **Thunar** | File manager (custom actions and shortcuts) |
| **nwg-look / qt6ct** | GTK and Qt theming |
| **Vim** | Editor config (`.vimrc`) |
| **Bash** | Fallback shell config (`.bashrc`) |

## Repository Layout

```
.
├── .bashrc
├── .vimrc
├── assets/
├── config/
│   ├── btop/
│   ├── fastfetch/        # config.jsonc + custom logos
│   ├── fish/
│   ├── hypr/             # hyprland.conf, keybinds, rules, scripts, themes...
│   ├── kitty/
│   ├── noctalia/         # settings, colors, plugins
│   ├── nwg-look/
│   ├── qt6ct/
│   ├── starship.toml
│   ├── Thunar/
│   ├── waybar/
│   └── wofi/
├── packages.txt          # packages to install
├── system.txt            # system details
└── readme.md
```

## Installation

> [!WARNING]
> These configs will overwrite existing files. Back up your current `~/.config` first.

**1. Clone the repo**

```bash
git clone https://github.com/<your-username>/<your-repo>.git
cd <your-repo>/Arch-Hyprland/Full
```

**2. Install the packages**

```bash
sudo pacman -Syu --needed - < packages.txt
```

> AUR packages (if any) need to be installed with an AUR helper such as `yay` or `paru`.

**3. Back up and copy the configs**

```bash
mkdir -p ~/.config-backup
cp -r ~/.config ~/.config-backup/

cp -r config/* ~/.config/
cp .bashrc .vimrc ~/
```

**4. Log in to Hyprland**

Log out, then start a Hyprland session from your display manager or by running `Hyprland` from a TTY.

## Keybinds

All bindings live in `config/hypr/keybinds.conf`. The **keybind-cheatsheet** and **hyprland-keybinds** Noctalia plugins give you an on-screen reference without opening the file.

## Customization

| What | Where |
| :--- | :---- |
| Monitors | `config/hypr/monitors.conf` |
| Keyboard / mouse | `config/hypr/inputs.conf` |
| Autostart apps | `config/hypr/startup.conf` |
| Window rules | `config/hypr/windowrules.conf` |
| Animations | `config/hypr/animations.conf` |
| Colors / theme | `config/hypr/themes/theme.conf` |
| Idle / lock behavior | `config/hypr/hypridle.conf` |
| Default browser launcher | `config/hypr/Scripts/browser-launcher.sh` |
| Bar layout and style | `config/waybar/config.jsonc`, `style.css` |
| Launcher style | `config/wofi/config`, `style.css` |

The `Original/` folders inside `waybar` and `wofi` hold the stock versions if you want to revert.

## Credits

- [Hyprland](https://hyprland.org/)
- [Waybar](https://github.com/Alexays/Waybar)
- [Noctalia](https://github.com/noctalia-dev)
- [Arch Linux](https://archlinux.org/)

---

<div align="center">

Made with ♥ on Arch, btw.

</div>
