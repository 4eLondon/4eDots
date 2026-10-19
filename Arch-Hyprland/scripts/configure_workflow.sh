#!/bin/bash
set -euo pipefail
REPO_DIR="$(pwd)"

echo -e "\n+ + [ Now configuring desktop environment ] + + \n"

echo -e " [Development] \n"

read -p "Install and configure git?: (y/n)" gitcheck

if [[ "$gitcheck" == 'y' || "$gitcheck" == 'Y' ]]; then
    sudo pacman -S git git-delta onefetch

    read -p "Enter your git user name: " gitUsername
    git config --global user.name "$gitUsername"
    
    read -p "Enter your git email: " gitEmail
    git config --global user.email "$gitEmail"

    cat >> ~/.gitconfig << 'EOF'
[push]
    autoSetupRemote = true
[core]
    pager = delta
[interactive]
    diffFilter = delta --color-only
EOF

if ! grep -q '# + + [ Git Aliases ]' ~/.bashrc; then
  sed -i '/# = = = = = Aliases = = = = =/a \
    # + + [ Git Aliases ]\
    alias gs="git status"\
    alias ga="git add"\
    alias gd="git diff HEAD --"\
    alias gc="git checkout"\
    alias gb="git branch"\
    alias gpu="git pull"\
    alias gr="git rm"\
    alias gp="git push"\
    alias gmr="git merge"\
    alias gl="git log --oneline --graph --decorate --all -10"\
    alias gll="git log --oneline --graph --decorate --all"\
    alias gm="git commit -m"\
    alias of="onefetch"\
  ' ~/.bashrc

sed -i '/^PS1=/d' ~/.bashrc

cat > /tmp/gitprompt_block.txt << 'EOF'
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

PS1='\[\033[34m\]\u\[\033[00m\]@\[\033[36m\]\h\[\033[00m\]:\[\033[34m\]\w\[\033[32m\]$(parse_git)\[\033[00m\]  \[\033[35m\][\t]\[\033[00m\]\$ '
EOF

if ! grep -q "parse_git()" ~/.bashrc; then
  sed -i "/# = = = = = Functions = = = = =/r /tmp/gitprompt_block.txt" ~/.bashrc
  echo "   git prompt added"
else
  echo "   git prompt already present, skipping"
fi

rm /tmp/gitprompt_block.txt

fi

else
    echo "Skipping git install"
fi


echo -e " [Networking] \n"

read -p "Install ssh?: (y/n)" sshcheck

if [[ "$sshcheck" == 'y' || "$sshcheck" == 'Y' ]]; then
    sudo pacman -S openssh
    sudo systemctl enable sshd
    sudo systemctl start --now sshd
    sudo systemctl status sshd

    echo -e " - ( Configuring ufw to limit ssh ) - \n"
    sudo ufw limit ssh

else
    echo "Skipping SSH install"
fi

echo -e "\n+ + [ Done ] + + \n"
echo "\n+ + [ User Workflow configured ] + +\n"
