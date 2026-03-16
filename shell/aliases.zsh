# Shortcuts
alias reloadshell="source ~/.zshrc"
alias reloadhammer='hs -c "hs.reload()"'

alias reload="reloadshell && reloadhammer"

alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias ll="/opt/homebrew/opt/coreutils/libexec/gnubin/ls -AhlFo --color --group-directories-first"
alias '..'="cd .."
alias '...'="cd ../.."
alias speed='speedtest'

# Directories
alias z="cd ~"
alias dot="cd $DOTFILES"
alias p="cd $HOME/Projects"
alias b="cd $HOME/Business"
alias pc="cd $HOME/Clones"
alias icloud="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/"
alias nt="cd ~/Notes"

# Laravel
alias a="php artisan"
alias am="php artisan migrate"
alias ar="php artisan migrate:rollback"

#AI
alias cl="claude --dangerously-skip-permissions"
alias co='codex --yolo -c "model_reasoning_effort=high"'
unalias c 2>/dev/null
alias c='codex --yolo -c "model_reasoning_effort=low"'
alias op="opencode"
alias ag="cd $DOTFILES/agents"

# Python
alias py="python"

# PHP
alias cfresh="rm -rf vendor/ composer.lock && composer i"

# JS
unalias dev 2>/dev/null
unalias run 2>/dev/null
unalias build 2>/dev/null
unalias nr 2>/dev/null
function _node_package_runner() {
  if [[ -f pnpm-lock.yaml ]]; then
    echo "pnpm"
  elif [[ -f yarn.lock ]]; then
    echo "yarn"
  else
    echo "npm"
  fi
}
function _is_tauri_project() {
  [[ -d src-tauri || -f src-tauri/tauri.conf.json || -f src-tauri/tauri.conf.json5 || -f src-tauri/tauri.conf.toml ]]
}
function dev {
  local runner
  runner=$(_node_package_runner)
  if _is_tauri_project; then
    if [[ $runner == "yarn" ]]; then
      yarn tauri dev "$@"
    else
      "$runner" tauri dev "$@"
    fi
    return
  fi
  if [[ $runner == "yarn" ]]; then
    yarn dev "$@"
  else
    "$runner" run dev "$@"
  fi
}
function run {
  local runner
  runner=$(_node_package_runner)
  if [[ $# -eq 0 ]]; then
    if [[ $runner == "yarn" ]]; then
      yarn run
    else
      "$runner" run
    fi
    return
  fi

  if [[ $runner == "yarn" ]]; then
    yarn "$@"
  else
    "$runner" run "$@"
  fi
}
function build {
  local runner
  runner=$(_node_package_runner)
  if [[ $runner == "yarn" ]]; then
    yarn build "$@"
  else
    "$runner" run build "$@"
  fi
}

# SSH
alias ssh-radxa='ssh root@192.168.1.93'

alias ssh-netcup-amiable-shadow="ssh ploi@152.53.82.25"
alias ssh-hetzner-gorgeous-flower="ssh ploi@128.140.5.136"
alias ssh-hetzner-blushing-storm="ssh ploi@188.245.170.184"
alias ssh-openclaw="ssh claw@89.167.111.23"
alias oc="ssh-openclaw"
alias server-bootstrap="$DOTFILES/scripts/server-bootstrap.sh"

# Brew
alias bi="brew info"
alias bs="brew search"
alias ba="brew install"
alias bac="brew install --cask"

alias mysql="/opt/homebrew/opt/mysql@8.4/bin/mysql -u root"

# Git
alias gs='git status'
alias ga='git add -A'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gho='gh repo view --web'

# Zed editor
alias zed='/Applications/Zed.app/Contents/MacOS/cli -n --wait'

# VS Code
alias code='code -n --wait'

# File Operations
copy() { cat "$1" | pbcopy; }
