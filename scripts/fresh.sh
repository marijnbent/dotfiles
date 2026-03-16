#!/bin/sh

# Run from dotfiles root regardless of where the script is called from
cd "$(dirname "$0")/.."

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Symlink .zshrc
rm -rf ~/.zshrc
ln -s ~/.dotfiles/.zshrc ~/.zshrc

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file ./Brewfile

# Create project directories
mkdir -p $HOME/Sites $HOME/Projects

# Hammerspoon
ln -sf ~/.dotfiles/config/hammerspoon ~/.hammerspoon

# Ghostty
mkdir -p ~/.config/ghostty
ln -sf ~/.dotfiles/config/ghostty.conf ~/.config/ghostty/config

# Karabiner
mkdir -p $HOME/.config/karabiner/assets/complex_modifications
ln -sf ~/.dotfiles/config/karabiner/assets/complex_modifications/capslock-hyper.json \
  $HOME/.config/karabiner/assets/complex_modifications/capslock-hyper.json

# Notes sync LaunchAgent
ln -sf "$HOME/.dotfiles/launch-agents/com.marijn.notes-sync.plist" \
    "$HOME/Library/LaunchAgents/com.marijn.notes-sync.plist"
launchctl load "$HOME/Library/LaunchAgents/com.marijn.notes-sync.plist" 2>/dev/null || true

# Set macOS preferences — run last as it reloads the shell
source ./scripts/macos.sh

# Set Python using pyenv
pyenv install 3.11
pyenv global 3.11
