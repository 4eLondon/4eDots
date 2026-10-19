#!/bin/bash
set -euo pipefail
REPO_DIR="$(pwd)"

echo -e "\n+ + [ Now configuring terminal ] + + \n"

echo -e " - ( Installing extended terminal tools )  - \n"
sudo pacman -S --needed --noconfirm eza fzf bat zoxide man-db man-pages btop pfetch vim nvim yazi

echo -e " - ( Configuring extended terminal tools )  - \n"
cp -rv "$REPO_DIR/Minimal/.config/nvim"    ~/.config/nvim
cp -rv "$REPO_DIR/Minimal/.config/.vimrc"    ~/

read -p "Would you like to overwrite the bashrc? (Y/N)" bashrcChoice

if [[ "$bashrcChoice" == "Y" || "$bashrcChoice" == "y" ]];then
    echo -e " - ( Writing core features to bashrc )  - \n"
    echo "" > ~/.bashrc
    cat >> ~/.bashrc << 'EOF'
#
# ~/.bashrc
#

# = = = = = General = = = = =

# -- Defaults
[[ $- != *i* ]] && return
export TERM=xterm-256color
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PAGER="less -R"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"

EOF

sleep 1s
echo -e " - ( Writing history and preformance improvements to bashrc )  - \n"
cat >> ~/.bashrc << 'EOF'
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
HISTSIZE=100000
HISTFILESIZE=200000
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

EOF
     
sleep 1s
echo -e " - ( Writing PS1 to bashrc )  - \n"
cat >> ~/.bashrc << 'EOF'   
# -- PS1
PS1='\[\033[34m\]\u\[\033[00m\]@\[\033[36m\]\h\[\033[00m\]: \[\033[34m\]\w\[\033[00m\] \[\033[35m\][\t]\[\033[00m\]\$ '

EOF

sleep 1s
echo -e " - ( Writing core simple aliases to bashrc )  - \n"
cat >> ~/.bashrc << 'EOF'   
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
alias cal='cal -3'


EOF

sleep 1s
echo -e " - ( Writing extended terminal tool aliases to bashrc )  - \n"
cat >> ~/.bashrc << 'EOF'  

# + + [ Tool Aliases ]
export BAT_THEME="Nord"
export EDITOR=nvim
eval "$(zoxide init bash)"
eval "$(fzf --bash)"
alias ll='eza -a --color=auto --icons'
alias lo='eza --tree -a --icons -I ".git|node_modules|.venv"'
alias copy='wl-copy'
alias pf='pfetch'
alias v='nvim'
alias vv='vim'
alias fir='firefox'
alias fira='firefox --private-window'

EOF

sleep 1s
echo -e " - ( Writing extended terminal tool aliases to bashrc )  - \n"
cat >> ~/.bashrc << 'EOF'  
# = = = = = Functions = = = = =

# --Yazi cd on close
function yy() {
local tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# --Extract archives
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

EOF

source ~/.bashrc
echo -e "\n+ + [ Done ] + + \n"
echo -e "\n+ + [ Terminal, extended terminal tools and bashrc configured] + + \n"
pacman -Qe | grep -i -e "fzf" -e "bat" -e "eza" -e "zoxide" -e "man-" -e "btop" -e "pfetch" -e "vim"
echo -e "\n - (First 20 lines of bashrc) - \n"
head -20 ~/.bashrc

else

cat >> ~/.bashrc << 'EOF'  
#
# ~/.bashrc
#

# = = = = = General = = = = =
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
HISTSIZE=100000
HISTFILESIZE=200000
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

# -- Evals
eval "$(zoxide init bash)"
eval "$(fzf --bash)"

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
alias cal='cal -3'

# = = = = = Functions = = = = =

EOF

echo -e "\n+ + [ Done ] + + \n"
echo -e "\n+ + [ Extened terminal tool configured ] + + \n"
pacman -Qe | grep -i -e "fzf" -e "bat" -e "eza" -e "zoxide" -e "man-" -e "btop" -e "pfetch" -e "vim"
fi
