#!/bin/bash

file="$HOME/.bashrc"
module=""

echo ""
echo "========================================================"
echo "              Bash Configuration Initializer            "
echo "========================================================"
echo ""
echo "Initializing default files..."
echo "Would you like a manual configuration or only the basics?"
echo "Manual[1] Basics[2]"
read choice

if [ "$choice" -eq 1 ]; then
    echo ""
    echo "========================================================"
    echo "                 Manual Configuration                   "
    echo "========================================================"
    echo ""
    echo "Customize your $file by selecting from a set of modules."
    echo ""

    echo "Would you like git support? (y/n)"
    read ans
    if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
        module="$module
# + + + + + Git + + + + +
alias gs='git status'
alias ga='git add'
alias gd='git diff'
alias gc='git checkout'
alias gb='git branch'
alias gpu='git push'
alias gp='git pull'
alias gmr='git merge'
alias gl='git log --oneline --graph --decorate --all -20'
alias gla='git log --oneline --graph --decorate --all'
alias gm='git commit -m'

parse_git() {
  local branch=\"\$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)\"
  [ -z \"\$branch\" ] && return
  local p=\"\$(git status --porcelain 2>/dev/null)\"
  local s=\"\"
  echo \"\$p\" | grep -q \"^??\" && s=\"?\"
  echo \"\$p\" | grep -q \"^.M\"  && s=\"\${s}*\"
  git diff --staged --quiet 2>/dev/null || s=\"\${s}+\"
  if [ \"\$branch\" = \"main\" ] || [ \"\$branch\" = \"master\" ]; then
    echo \" (\$branch)\$s\"
  else
    echo \" [\$branch]\$s\"
  fi
}
PS1='\''\\u@\\h:\\w\\[\\033[32m\\]\$(parse_git)\\[\\033[00m\\]\$ '\''"
    fi

    echo "Do you use zoxide? (y/n)"
    read ans
    if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
        module="$module
# + + + + + Zoxide + + + + +
eval \"\$(zoxide init bash)\""
    fi

    echo "Add archive extraction function? (y/n)"
    read ans
    if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
        module="$module
# + + + + + Extract + + + + +
extr() {
    if [ -f \"\$1\" ]; then
        case \"\$1\" in
            *.tar.bz2) tar xjf \"\$1\" ;;
            *.tar.gz)  tar xzf \"\$1\" ;;
            *.bz2)     bunzip2 \"\$1\" ;;
            *.rar)     unrar x \"\$1\" ;;
            *.gz)      gunzip \"\$1\" ;;
            *.tar)     tar xf \"\$1\" ;;
            *.tbz2)    tar xjf \"\$1\" ;;
            *.tgz)     tar xzf \"\$1\" ;;
            *.zip)     unzip \"\$1\" ;;
            *.Z)       uncompress \"\$1\" ;;
            *.7z)      7z x \"\$1\" ;;
            *)         echo \"Cannot extract: \$1\" ;;
        esac
    else
        echo \"File not found: \$1\"
    fi
}"
    fi

    echo "Would you like yazi support? (y/n)"
    read ans
    if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
        module="$module
# + + + + + Yazi + + + + +
yy() {
  local tmp=\"\$(mktemp -t yazi-cwd.XXXXXX)\"
  yazi \"\$@\" --cwd-file=\"\$tmp\"
  if cwd=\"\$(cat -- \"\$tmp\")\" && [ -n \"\$cwd\" ] && [ \"\$cwd\" != \"\$PWD\" ]; then
    cd -- \"\$cwd\"
  fi
  rm -f -- \"\$tmp\"
}"
    fi

    echo "Do you use fzf? (y/n)"
    read ans
    if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
        module="$module
# + + + + + Fzf + + + + +
eval \"\$(fzf --bash)\"
export FZF_DEFAULT_COMMAND='find . -type f'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
alias fv='fzf | xargs nvim'
alias fcd='cd \"\$(find . -type d | fzf)\"'"
    fi

    echo "Do you use SSH? (y/n)"
    read ans
    if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
        module="$module
# + + + + + SSH + + + + +
alias ssha='eval \"\$(ssh-agent -s)\" && ssh-add'
alias sshk='ssh-add -l'
alias sshkill='kill \$SSH_AGENT_PID'
alias scp='scp -r'"
    fi

    echo "Do you use eza? (y/n)"
    read ans
    if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
        module="$module
# + + + + + Eza + + + + +
alias ll='eza -a --color=auto --icons'
alias lo='eza --tree -a --icons'"
    fi

    echo "Do you use neovim? (y/n)"
    read ans
    if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
        module="$module
# + + + + + Neovim + + + + +
export EDITOR=nvim
export GIT_EDITOR=nvim
alias v='nvim'
alias vd='nvim -d'
alias vr='nvim -R'
alias nvrc='nvim \$HOME/.config/nvim/init.lua'
alias nvcfg='cd \$HOME/.config/nvim && nvim .'"
    fi

    echo "Do you use ripgrep/fd? (y/n)"
    read ans
    if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
        module="$module
# + + + + + Ripgrep/fd + + + + +
alias rg='rg --color=always'
alias rgi='rg -i'
alias rgf='rg -l'
alias fd='fd --color=always'
alias fda='fd -H'
alias fdf='fd -t f'
alias fdd='fd -t d'"
    fi

    echo "Do you use docker? (y/n)"
    read ans
    if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
        module="$module
# + + + + + Docker + + + + +
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcr='docker compose restart'
alias dcp='docker compose pull'"
    fi

    echo "Do you use Python? (y/n)"
    read ans
    if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
        module="$module
# + + + + + Python + + + + +
alias py='python3'
alias pip='pip3'
alias newve='python3 -m venv .venv'
alias openve='source .venv/bin/activate'
alias closeve='deactivate'"
    fi

    cat > "$file" << 'EOF'
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

# = = = = = Performance = = = = =
shopt -s cdable_vars
shopt -s cmdhist
shopt -s lithist
shopt -s cdspell
shopt -s dotglob
shopt -s nocaseglob

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
EOF

    if [ -n "$module" ]; then
        printf '%s\n' "$module" >> "$file"
    else
        echo "PS1='\\u@\\h:\\w\\\$ '" >> "$file"
    fi

    echo ""
    echo "Successfully configured $file."

elif [ "$choice" -eq 2 ]; then
    echo ""
    echo "========================================================"
    echo "!!! WARNING - This process will override your bashrc !!!"
    echo "========================================================"
    echo ""
    echo "Do you wish to proceed? (y/n)"
    read confirm

    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        cat > "$file" << 'EOF'
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export TERM=xterm-256color
PS1='\u@\h:\w\$ '

# = = = = = Defaults = = = = =
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PAGER=less
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export PATH="$HOME/.local/bin:$PATH"

# = = = = = Performance = = = = =
shopt -s cdable_vars
shopt -s cmdhist
shopt -s lithist
shopt -s cdspell
shopt -s dotglob
shopt -s nocaseglob

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
EOF
        echo ""
        echo "Successfully configured $file."
    else
        echo "Operation halted."
    fi

else
    echo "Invalid choice. Please enter 1 or 2."
fi
