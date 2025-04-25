#!/bin/bash

# Create config path
mkdir -p ~/.config

# Link config if not already linked
if [ ! -d ~/.config/nvim ]; then
  ln -s ~/.dotfiles/.config/nvim ~/.config/nvim
fi

# Install required tools
sudo apt-get update
sudo apt-get install -y ripgrep fd-find
