#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export TERM=xterm-256color

# = = = = = Defaults = = = = =
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PAGER=less
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export PATH="$HOME/.local/bin:$PATH"
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"

# = = = = = Performance = = = = =
shopt -s cdable_vars
shopt -s cmdhist
shopt -s lithist
shopt -s cdspell
shopt -s dotglob
shopt -s nocaseglob
shopt -s nocasematch
shopt -s extglob

# = = = = = History = = = = =
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# = = = = = Base Aliases = = = = =
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias qe='pacman -Qe'
alias moc='mocp'

# + + + + + Git + + + + +
alias gs='git status'
alias ga='git add'
alias gd='git diff'
alias gc='git checkout'
alias gb='git branch'
alias gpu='git push'
alias gr='git rm'
alias gp='git pull'
alias gmr='git merge'
alias gl='git log --oneline --graph --decorate --all -20'
alias gla='git log --oneline --graph --decorate --all'
alias gm='git commit -m'

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

# + + + + + Zoxide + + + + +
eval "$(zoxide init bash)"

# + + + + + Extract + + + + +
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

# + + + + + Yazi + + + + +
function yy() {
local tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# + + + + + Fzf + + + + +
eval "$(fzf --bash)"
export FZF_DEFAULT_COMMAND='find . -type f'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
alias fv='fzf | xargs nvim'
alias fcd='cd "$(find . -type d | fzf)"'

# + + + + + SSH + + + + +

alias ssha='eval "$(ssh-agent -s)" && ssh-add'
alias sshk='ssh-add -l'
alias sshkill='kill $SSH_AGENT_PID'
alias scp='scp -r'

# + + + + + Eza + + + + +
alias ll='eza -a --color=auto --icons'
alias lo='eza --tree -a --icons'

# + + + + + Neovim + + + + +
export EDITOR=nvim
export GIT_EDITOR=nvim
alias v='nvim'
alias vd='nvim -d'
alias vr='nvim -R'
alias nvrc='nvim $HOME/.config/nvim/init.lua'
alias nvcfg='cd $HOME/.config/nvim && nvim .'

# + + + + + Ripgrep/fd + + + + +
alias rg='rg --color=always'
alias rgi='rg -i'
alias rgf='rg -l'
alias fd='fd --color=always'
alias fda='fd -H'
alias fdf='fd -t f'
alias fdd='fd -t d'

# + + + + + Docker + + + + +
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcr='docker compose restart'
alias dcp='docker compose pull'

# + + + + + Python + + + + +
alias py='python3'
alias pip='pip3'
alias newve='python3 -m venv .venv'
alias openve='source .venv/bin/activate'
alias closeve='deactivate'

# + + + + Ruby + + + +
[ -f "/home/london/.ghcup/env" ] && . "/home/london/.ghcup/env" # ghcup-env
. "$HOME/.cargo/env"
export PATH="$HOME/.local/share/gem/ruby/3.4.8/bin:$PATH"

# + + + +  Nim + + + +
export PATH=$PATH:~/.nimble/bin

# + + + + Bat + + + +
export BAT_THEME="Nord"
alias fir='firefox'
alias ff='fastfetch'
