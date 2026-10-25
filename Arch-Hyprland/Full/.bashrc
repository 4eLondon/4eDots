eval "$(starship init bash)"


alias lo='ls -R'
alias v='vim'
alias ff='fastfetch'


# History
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# Case insensitive completion
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"

# Quality of life shell options
shopt -s autocd
shopt -s cdspell
shopt -s dirspell
shopt -s globstar
shopt -s checkwinsize

# Prompt
eval "$(starship init bash)"

# Aliases - navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# Aliases - ls
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lah'
alias l='ls -la'

# Aliases - system
alias df='df -h'
alias free='free -h'
alias top='htop'
alias ports='ss -tulpn'
alias myip='curl ifconfig.me'

# Aliases - pacman
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias remove='sudo pacman -Rns'
alias search='pacman -Ss'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null'
alias installed='pacman -Qe'

# Aliases - git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph'

# Aliases - misc
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias reload='source ~/.bashrc'
alias bashrc='$EDITOR ~/.bashrc'
alias hyprconf='$EDITOR ~/.config/hypr/hyprland.conf'

# Exports
export EDITOR=vim
export VISUAL=vim
export BROWSER=firefox
export MANPAGER='less -R'

# Colors in man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Functions
mkcd() { mkdir -p "$1" && cd "$1"; }   

alias qe='pacman -Qe'
