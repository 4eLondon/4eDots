#
# ~/.bashrc
#

# = = = = = General = = = = =

# -- Defaults
[[ $- != *i* ]] && return
export TERM=xterm-256color
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PAGER=less
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export PATH="$HOME/.bin:$PATH"
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"

# -- Preformance
shopt -s cdable_vars
shopt -s cmdhist
shopt -s lithist
shopt -s cdspell
shopt -s dotglob
shopt -s nocaseglob
shopt -s nocasematch
shopt -s extglob

# -- History
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000


# = = = = = Aliases = = = = =

# + + [ Base Aliases ]
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ls='ls -a --color=auto'
alias grep='grep --color=auto'
alias qe='pacman -Qe'
alias df='df -h'
alias du='df -h'


# + + [ User Aliases ]

# --Text editors
alias v='nvim'
alias vv='vim'
export EDITOR=nvim

# --Python
alias py='python3'
alias pyserver='python -m http.server 8000 --directory ./public'
alias newve='python3 -m venv .venv'
alias openve='source .venv/bin/activate'
alias closeve='deactivate'

# --Tools
export BAT_THEME="Nord"
eval "$(zoxide init bash)"
eval "$(fzf --bash)"
alias ll='eza -a --color=auto --icons'
alias lo='eza --tree -a --icons'
alias copy='wl-copy'
alias ff='fastfetch'

# --Git
alias gs='git status'
alias ga='git add'
alias gd='git diff'
alias gc='git checkout'
alias gb='git branch'
alias gpu='git push'
alias gr='git rm'
alias gp='git pull'
alias gmr='git merge'
alias gl='git log --oneline --graph --decorate --all -10'
alias gla='git log --oneline --graph --decorate --all'
alias gm='git commit -m'

# --Misc
alias fir='firefox'
alias fira='firefox --private-window'

# = = = = = Functions = = = = =

# --Yazi
function yy() {
local tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# --MountUsb
usb() {
  local action=$1
  local device=$2
  local mountpoint="/mnt/${device}"

  case "$action" in
    mount)
      sudo mkdir -p "$mountpoint"
      sudo mount "/dev/${device}1" "$mountpoint"
      echo "Mounted /dev/${device}1 → $mountpoint"
      ;;
    umount|unmount)
      sudo umount "$mountpoint"
      echo "Unmounted $mountpoint"
      ;;
    eject)
      sudo umount "$mountpoint"
      sudo eject "/dev/${device}"
      echo "Ejected /dev/${device}"
      ;;
    info)
      lsblk "/dev/${device}"
      ;;
    *)
      echo "Usage: usb <mount|umount|eject|info> <sdb|sdc>"
      echo "  usb mount sdb      → mounts /dev/sdb1 to /mnt/sdb"
      echo "  usb umount sdc     → unmounts /mnt/sdc"
      echo "  usb eject sdb      → unmounts and ejects /dev/sdb"
      echo "  usb info sdc       → shows partition info for /dev/sdc"
      ;;
  esac
}


# --Extract
extr() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.rar)     unrar x "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.tbz2)    tar xjf "$1" ;;
            *.tgz)     tar xzf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1" ;;
            *)         echo "Cannot extract: $1" ;;
        esac
    else
        echo "File not found: $1"
    fi
}

# -- GitInfo
parse_git() {
  local branch="$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)"
  [ -z "$branch" ] && return
  local p="$(git status --porcelain 2>/dev/null)"
  local s=""

  local color_untracked=$'\001\033[31m\002'
  local color_modified=$'\001\033[33m\002'
  local color_staged=$'\001\033[32m\002'
  local reset_color=$'\001\033[00m\002'

  echo "$p" | grep -q "^??" && s="${color_untracked} ? ${reset_color}"
  echo "$p" | grep -q "^.M"  && s="${s}${color_modified} * ${reset_color}"
  git diff --staged --quiet 2>/dev/null || s="${s}${color_staged} + ${reset_color}"

  if [ "$branch" = "main" ] || [ "$branch" = "master" ]; then
    echo " ($branch)$s"
  else
    echo " [$branch]$s"
  fi
}

PS1='\[\033[34m\]\u\[\033[00m\]@\[\033[36m\]\h\[\033[00m\]:\[\033[34m\]\w\[\033[32m\]$(parse_git)\[\033[00m\]\$ '

