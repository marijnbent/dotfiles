#!/usr/bin/env bash
# server-bootstrap.sh — deploy shell config to a remote Linux server
# Usage: server-bootstrap.sh user@host
# Re-running is idempotent and refreshes server.zsh.

set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
SERVER_ZSH="$DOTFILES/shell/server.zsh"

if [[ $# -ne 1 ]]; then
  echo "Usage: $(basename "$0") user@host" >&2
  exit 1
fi

TARGET="$1"

echo "==> Copying shell config to $TARGET..."
scp "$SERVER_ZSH" "$TARGET:/tmp/server.zshrc"

echo "==> Setting up zsh and plugins on $TARGET..."
ssh "$TARGET" bash <<'ENDSSH'
set -euo pipefail

# Install zsh if missing
if ! command -v zsh &>/dev/null; then
  echo "Installing zsh..."
  sudo apt-get install -y zsh
fi

# Set up plugin directory
mkdir -p ~/.zsh/plugins

# Clone plugins (skip if already present)
if [[ ! -d ~/.zsh/plugins/zsh-autosuggestions ]]; then
  echo "Cloning zsh-autosuggestions..."
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
    ~/.zsh/plugins/zsh-autosuggestions
fi

if [[ ! -d ~/.zsh/plugins/zsh-syntax-highlighting ]]; then
  echo "Cloning zsh-syntax-highlighting..."
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
    ~/.zsh/plugins/zsh-syntax-highlighting
fi

# Install config
cp /tmp/server.zshrc ~/.zshrc
rm /tmp/server.zshrc
echo "Config installed."

# Set default shell to zsh if not already
if [[ "$SHELL" != "$(which zsh)" ]]; then
  echo "Changing default shell to zsh..."
  chsh -s "$(which zsh)"
fi
ENDSSH

echo ""
echo "Done. Changes take effect on next login."
echo "  ssh $TARGET"
