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
alias co='codex --yolo -c "model_reasoning_effort=high"'
alias cof='codex --yolo -c "model_reasoning_effort=low"'
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
  local root scan_root is_git_root
  local -a repo_targets
  local -a committed_msgs
  local -a pushed_msgs
  local -a push_notes

  _gg_push_repo() {
    local dir=$1
    local prev_dir=$PWD
    local name upstream ahead_count hash dry_run
    name=$(basename "$dir")
    cd "$dir" || return

    dry_run=$(git push --dry-run --porcelain 2>/dev/null)
    if [[ $? -ne 0 ]]; then
      push_notes+=("$name  no configured push destination")
      cd "$prev_dir" || return
      return
    fi

    if [[ $dry_run == *$'\t[up to date]'* ]]; then
      cd "$prev_dir" || return
      return
    fi

    if upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null); then
      ahead_count=$(git rev-list --count "${upstream}..HEAD" 2>/dev/null)
    else
      ahead_count=""
    fi

    git push -q
    hash=$(git rev-parse --short HEAD)
    if [[ -n $ahead_count && $ahead_count -gt 0 ]]; then
      pushed_msgs+=("$name  $hash  pushed $ahead_count commit(s)")
    else
      pushed_msgs+=("$name  $hash  pushed existing commits")
    fi
    cd "$prev_dir" || return
  }

  _gg_commit_repo() {
    local dir=$1 push=$2
    local prev_dir=$PWD
    local name
    name=$(basename "$dir")
    cd "$dir" || return
    git add -A
    if git diff --staged --quiet; then
      cd "$prev_dir" || return
      return
    fi
    local msg
    local _tmp
    _tmp=$(mktemp)
    codex exec --ephemeral -c "model_reasoning_effort=low" --color never -o "$_tmp" \
      "Write a concise single-line git commit message for these changes. Output only the message, no quotes or explanation.

$(git diff --staged)" >/dev/null 2>&1
    msg=$(cat "$_tmp")
    rm -f "$_tmp"
    git commit -q -m "$msg"
    local hash
    hash=$(git rev-parse --short HEAD)
    committed_msgs+=("$name  $hash  $msg")
    [[ $push == 1 ]] && git push -q
    cd "$prev_dir" || return
  }

  if root=$(git rev-parse --show-toplevel 2>/dev/null); then
    is_git_root=1

    # Commit any submodules first
    while IFS= read -r nested; do
      [[ -n $nested ]] && repo_targets+=("$nested")
    done < <(git -C "$root" submodule foreach --recursive --quiet 'echo "$toplevel/$sm_path"' 2>/dev/null)

    # Commit root last so parent repos can record updated submodule pointers.
    repo_targets+=("$root")
  else
    is_git_root=0
    scan_root=$PWD
    while IFS= read -r nested; do
      [[ -n $nested ]] && repo_targets+=("$nested")
    done < <(find -L "$scan_root" -mindepth 2 \( -type d -name .git -prune -print -o -type f -name .git -print \) 2>/dev/null | while IFS= read -r git_entry; do dirname "$git_entry"; done | sort -u)

    if (( ${#repo_targets[@]} == 0 )); then
      echo "Not a git repo and no nested git repos found"
      return 1
    fi
  fi

  for nested in "${repo_targets[@]}"; do
    _gg_commit_repo "$nested" ${1:-0}
    [[ ${1:-0} == 1 ]] && _gg_push_repo "$nested"
  done

  unfunction _gg_push_repo 2>/dev/null
  unfunction _gg_commit_repo 2>/dev/null

  if (( ${#committed_msgs[@]} > 0 || ${#pushed_msgs[@]} > 0 || ${#push_notes[@]} > 0 )); then
    echo ""
    for m in "${committed_msgs[@]}"; do echo "  ✓ $m"; done
    for m in "${pushed_msgs[@]}"; do echo "  ↑ $m"; done
    for m in "${push_notes[@]}"; do echo "  ! $m"; done
  else
    if [[ $is_git_root == 1 ]]; then
      if [[ ${1:-0} == 1 ]]; then
        echo "  nothing to commit or push"
      else
        echo "  nothing to commit"
      fi
    else
      if [[ ${1:-0} == 1 ]]; then
        echo "  no changes or outgoing commits found in nested git repos"
      else
        echo "  no changes found in nested git repos"
      fi
    fi
  fi
}

function ggg { gg 1 }

# Zed editor
alias zed='/Applications/Zed.app/Contents/MacOS/cli -n --wait'

# File Operations
copy() { cat "$1" | pbcopy; }
