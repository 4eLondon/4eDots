# Starship prompt
starship init fish | source

# Case insensitive completion (fish does this by default)
set -g fish_complete_path $fish_complete_path

# Exports
set -gx EDITOR vim
set -gx VISUAL vim
set -gx BROWSER firefox
set -gx MANPAGER 'less -R'

# Aliases - navigation
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'

# Aliases - ls
alias ls 'ls --color=auto --group-directories-first'
alias ll 'ls -lah'
alias l 'ls -la'
alias lt 'ls -lahtr'
alias lz 'ls -lahSr'
alias lo 'ls -R'

# Aliases - system
alias df 'df -h'
alias free 'free -h'
alias top 'htop'
alias ports 'ss -tulpn'
alias myip 'curl ifconfig.me'
alias v 'vim'
alias ff 'fastfetch'

# Aliases - pacman
alias update 'sudo pacman -Syu'
alias install 'sudo pacman -S'
alias remove 'sudo pacman -Rns'
alias search 'pacman -Ss'
alias installed 'pacman -Qe'
alias cleanup 'sudo pacman -Rns (pacman -Qtdq)'

# Aliases - git
alias gs 'git status'
alias ga 'git add'
alias gc 'git commit'
alias gp 'git push'
alias gl 'git log --oneline --graph'

# Aliases - misc
alias grep 'grep --color=auto'
alias diff 'diff --color=auto'
alias reload 'source ~/.config/fish/config.fish'
alias fishconf '$EDITOR ~/.config/fish/config.fish'
alias hyprconf '$EDITOR ~/.config/hypr/hyprland.conf'

# Functions
function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end
