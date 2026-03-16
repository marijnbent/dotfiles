export DOTFILES=$HOME/.dotfiles

# oh-my-zsh settings (read by use-omz)
ZSH_THEME="robbyrussell"
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="dd/mm/yyyy"

# antidote
source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
antidote load $DOTFILES/.zsh_plugins.txt

# shell config
for _f in $DOTFILES/shell/*.zsh; do source "$_f"; done
unset _f

# history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS

# navigation
setopt AUTO_CD

# fzf
source <(fzf --zsh)

# editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='zed --wait'
  export VISUAL='zed --wait'
fi

ARTISAN_OPEN_ON_MAKE_EDITOR=zed

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
