#!/bin/bash

if [ -z "$USER" ]; then
    USER=$(id -un)
fi

echo >&2 "====================================================================="
echo >&2 " Setting up codespaces environment"
echo >&2 ""
echo >&2 " USER        $USER"
echo >&2 " HOME        $HOME"
echo >&2 "====================================================================="

# Backup existing .dotfiles directory if it exists
if [[ -d $HOME/.dotfiles ]]; then
  echo "Backing up existing .dotfiles directory"
  mv $HOME/.dotfiles $HOME/.dotfiles.backup || echo "Backup failed"
fi

# Clone the dotfiles repository
if [[ -n "$PAT_TOKEN" ]]; then
  echo "Using PAT token to clone repository"
  git clone --depth 1 --recurse-submodules --shallow-submodules https://${GITHUB_USER}:${PAT_TOKEN}@github.com/${GITHUB_USER}/triton-dotfiles.git $HOME/.dotfiles
else
  echo "Cloning repository without PAT token"
  git clone https://github.com/${GITHUB_USER}/triton-dotfiles.git $HOME/.dotfiles
fi

# Do the rest of the tasks from the home dir
cd $HOME

# create bindir
mkdir -p $HOME/bin

# Make passwordless sudo work
#export SUDO_ASKPASS=/bin/true

# A bit of a hack
[ -f .gitconfig ] && mv .gitconfig .gitconfig.private
[ -f .bashrc ] && mv .bashrc .bashrc.dist
# Run dotfiles.symlink if it exists
if [[ -x $HOME/.dotfiles/bin/dotfiles.symlink ]]; then
  $HOME/.dotfiles/bin/dotfiles.symlink install
else
  echo "Missing dotfiles.symlink"
fi

# Setting proper terminal
if [[ -n "$FISH"  ]]; then
  echo "Setting shell to fish"
  sudo chsh -s /usr/bin/fish $USER
elif [[ -n "$ZSH" ]]; then
  echo "Setting shell to zsh"
  sudo chsh -s /usr/bin/zsh $USER
else
  echo "Setting shell to bash"
  sudo chsh -s /usr/bin/bash $USER
fi

# Install fzf
FZF_VERSION=0.30.0
echo "Install fzf to version 0.30.0"
curl -s -L https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz | tar xzC $HOME/bin

PATH=${PATH}:/opt/nvim/bin/

# Create config path
# mkdir -p ~/.config
#
# # Link config if not already linked
# if [ ! -d ~/.config/nvim ]; then
#   ln -s ~/.dotfiles/.config/nvim ~/.config/nvim
# fi
#
# Install required tools
sudo apt-get update
sudo apt-get install -y ripgrep fd-find
