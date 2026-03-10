# Path to your dotfiles.
export DOTFILES=$HOME/.dotfiles

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="dd/mm/yyyy"

zstyle ':omz:update' mode auto

ZSH_CUSTOM=$DOTFILES

plugins=(artisan brew git zsh-autosuggestions zsh-autocomplete zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# History
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS

# Navigation
setopt AUTO_CD

# fzf
source <(fzf --zsh)

# Preferred editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='zed'
fi

ARTISAN_OPEN_ON_MAKE_EDITOR=code

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
