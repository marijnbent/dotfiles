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
alias dot="cd $DOTFILES"
alias p="cd $HOME/Projects"
alias pc="cd $HOME/Clones"
alias icloud="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/"
alias nt="cd ~/Notes"

# Laravel
alias a="php artisan"
alias am="php artisan migrate"
alias ar="php artisan migrate:rollback"

#AI
alias cl="claude --dangerously-skip-permissions"
alias co='codex --yolo -c "service_tier=flex" -c "model_reasoning_effort=high"'
alias cof='codex --yolo -c "service_tier=flex" -c "model_reasoning_effort=low"'
alias op="opencode"
alias ag="cd $DOTFILES/agents"

# Python
alias py="python"

# PHP
alias cfresh="rm -rf vendor/ composer.lock && composer i"

# JS
alias dev="npm run dev"
alias build="npm run build"
alias nr="npm run"

# SSH
alias ssh-radxa='ssh root@192.168.1.93'

alias ssh-netcup-amiable-shadow="ssh ploi@152.53.82.25"
alias ssh-hetzner-gorgeous-flower="ssh ploi@128.140.5.136"
alias ssh-hetzner-blushing-storm="ssh ploi@188.245.170.184"
alias ssh-openclaw="ssh claw@89.167.111.23"
alias oc="ssh-openclaw"

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

# Auto-generate commit message with Claude, commit and push
# Supports monorepos: commits nested repos first, then root
unalias gg 2>/dev/null
function gg {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "Not a git repo"; return 1; }

  local -a committed_msgs

  _gg_commit_repo() {
    local dir=$1 push=$2
    local name
    name=$(basename "$dir")
    cd "$dir" || return
    git add -A
    [[ -z $(git diff --staged) ]] && return
    local msg
    msg=$(git diff --staged | claude -p "Write a concise single-line git commit message for these changes. Output only the message, no quotes or explanation.")
    git commit -q -m "$msg"
    local hash
    hash=$(git rev-parse --short HEAD)
    committed_msgs+=("$name  $hash  $msg")
    [[ $push == 1 ]] && git push -q
    cd "$root"
  }

  # Commit any submodules first
  while IFS= read -r nested; do
    _gg_commit_repo "$nested" ${1:-0}
  done < <(git -C "$root" submodule foreach --recursive --quiet 'echo "$toplevel/$sm_path"' 2>/dev/null)

  # Commit root (push if requested)
  _gg_commit_repo "$root" ${1:-0}

  unfunction _gg_commit_repo 2>/dev/null

  if (( ${#committed_msgs[@]} > 0 )); then
    echo ""
    for m in "${committed_msgs[@]}"; do echo "  ✓ $m"; done
  else
    echo "  nothing to commit"
  fi
}

function ggg { gg 1 }

# Zed editor
alias zed='/Applications/Zed.app/Contents/MacOS/cli -n --wait'

# File Operations
copy() { cat "$1" | pbcopy; }
