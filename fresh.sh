#!/bin/sh

echo "Setting up your Mac..."

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf ~/.zshrc
# ln -s .zshrc $HOME/.zshrc
ln -s ~/.dotfiles/.zshrc ~/.zshrc

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file ./Brewfile

# Create a projects directories
mkdir $HOME/Sites
mkdir $HOME/Projects
mkdir $HOME/Projects/wordproof

# Clone Github repositories
./clone.sh

# Symlink the Mackup config file to the home directory
ln -s ./.mackup.cfg $HOME/.mackup.cfg

# Set macOS preferences - we will run this last because this will reload the shell
source ./.macos

# Set Python using pyenv
pyenv install 3.11
pyenv global 3.11
