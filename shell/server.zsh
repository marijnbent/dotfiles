# server.zsh — standalone zshrc for Linux servers
# Drop-in replacement for ~/.zshrc on Ubuntu/Debian
# No macOS/Homebrew dependencies. Plugins sourced defensively.

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

# --- Navigation ---
setopt AUTO_CD

# --- Editor ---
export EDITOR='nano'

# --- PATH ---
export PATH="$HOME/.local/bin:./node_modules/.bin:./vendor/bin:$PATH"

# --- Aliases ---
alias reloadshell='exec zsh'
alias ll='ls -AhlF --color=auto --group-directories-first'
alias ..='cd ..'
alias ...='cd ../..'
alias py='python3'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gb='git branch'

# --- Plugins ---
ZSH_PLUGINS="$HOME/.zsh/plugins"

[[ -f "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] &&
  source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"

[[ -f "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] &&
  source "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# --- Prompt (vcs_info, no oh-my-zsh required) ---
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'
setopt PROMPT_SUBST
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f%F{yellow}${vcs_info_msg_0_}%f %# '
