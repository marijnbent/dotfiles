unalias g 2>/dev/null
function g {
  local root scan_root is_git_root
  local -a repo_targets
  local -a committed_msgs
  local -a pushed_msgs
  local -a push_notes

  _g_collect_nested_repos() {
    local scan_root=$1
    find -L "$scan_root" -mindepth 2 \
      \( -type d -name .git -prune -print -o -type f -name .git -print \) 2>/dev/null \
      | while IFS= read -r git_entry; do dirname "$git_entry"; done \
      | awk '!seen[$0]++ { depth=gsub(/\//, "/", $0); print depth "\t" $0 }' \
      | sort -rn -k1,1 -k2,2 \
      | cut -f2-
  }

  _g_fallback_commit_message() {
    local changed_count added_count modified_count deleted_count renamed_count
    changed_count=$(git diff --staged --name-only | wc -l | tr -d '[:space:]')
    added_count=$(git diff --staged --diff-filter=A --name-only | wc -l | tr -d '[:space:]')
    modified_count=$(git diff --staged --diff-filter=M --name-only | wc -l | tr -d '[:space:]')
    deleted_count=$(git diff --staged --diff-filter=D --name-only | wc -l | tr -d '[:space:]')
    renamed_count=$(git diff --staged --diff-filter=R --name-only | wc -l | tr -d '[:space:]')

    if [[ $deleted_count -gt 0 && $added_count -eq 0 && $modified_count -eq 0 && $renamed_count -eq 0 ]]; then
      echo "Remove $changed_count file(s)"
    elif [[ $added_count -gt 0 && $modified_count -eq 0 && $deleted_count -eq 0 && $renamed_count -eq 0 ]]; then
      echo "Add $changed_count file(s)"
    elif [[ $renamed_count -gt 0 && $added_count -eq 0 && $modified_count -eq 0 && $deleted_count -eq 0 ]]; then
      echo "Rename $changed_count file(s)"
    else
      echo "Update $changed_count file(s)"
    fi
  }

  _g_push_repo() {
    local dir=$1
    local prev_dir=$PWD
    local name upstream ahead_count hash dry_run dry_run_status error_summary
    name=$(basename "$dir")
    cd "$dir" || return

    dry_run=$(git push --dry-run --porcelain 2>&1)
    dry_run_status=$?
    if [[ $dry_run_status -ne 0 ]]; then
      if [[ $dry_run == *"No configured push destination"* || $dry_run == *"has no upstream branch"* ]]; then
        push_notes+=("$name  no configured push destination")
      else
        error_summary=$(printf '%s\n' "$dry_run" | sed '/^[[:space:]]*$/d' | sed -n '1p' | sed -e 's/^fatal: //' -e 's/^error: //')
        [[ -z $error_summary ]] && error_summary="push dry-run failed"
        push_notes+=("$name  push failed: $error_summary")
      fi
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

  _g_commit_repo() {
    local dir=$1 push=$2
    local prev_dir=$PWD
    local name msg _tmp diff_summary
    name=$(basename "$dir")
    cd "$dir" || return
    git add -A
    if git diff --staged --quiet; then
      cd "$prev_dir" || return
      return
    fi
    diff_summary=$(
      {
        git diff --staged --shortstat
        git diff --staged --summary
        git diff --staged --name-status | sed -n '1,200p'
      } | sed '/^[[:space:]]*$/d'
    )
    _tmp=$(mktemp)
    printf '%s\n\n%s\n' \
      "Write a concise single-line git commit message for these changes. Output only the message, no quotes or explanation." \
      "$diff_summary" \
      | codex exec --ephemeral -c "service_tier=fast" -c "model_reasoning_effort=low" --color never -o "$_tmp" - >/dev/null 2>&1
    msg=$(tr '\n' ' ' < "$_tmp" | sed -e 's/[[:space:]]\+/ /g' -e 's/^ //' -e 's/ $//')
    rm -f "$_tmp"
    if [[ -z $msg ]]; then
      msg=$(_g_fallback_commit_message)
    fi
    git commit -q -m "$msg"
    local hash
    hash=$(git rev-parse --short HEAD)
    committed_msgs+=("$name  $hash  $msg")
    [[ $push == 1 ]] && git push -q
    cd "$prev_dir" || return
  }

  if root=$(git rev-parse --show-toplevel 2>/dev/null); then
    is_git_root=1
    while IFS= read -r nested; do
      [[ -n $nested ]] && repo_targets+=("$nested")
    done < <(_g_collect_nested_repos "$root")
    repo_targets+=("$root")
  else
    is_git_root=0
    scan_root=$PWD
    while IFS= read -r nested; do
      [[ -n $nested ]] && repo_targets+=("$nested")
    done < <(_g_collect_nested_repos "$scan_root")
    if (( ${#repo_targets[@]} == 0 )); then
      echo "Not a git repo and no nested git repos found"
      return 1
    fi
  fi

  for nested in "${repo_targets[@]}"; do
    _g_commit_repo "$nested" ${1:-0}
    [[ ${1:-0} == 1 ]] && _g_push_repo "$nested"
  done

  unfunction _g_push_repo 2>/dev/null
  unfunction _g_commit_repo 2>/dev/null
  unfunction _g_collect_nested_repos 2>/dev/null
  unfunction _g_fallback_commit_message 2>/dev/null

  if (( ${#committed_msgs[@]} > 0 || ${#pushed_msgs[@]} > 0 || ${#push_notes[@]} > 0 )); then
    echo ""
    for m in "${committed_msgs[@]}"; do echo "  ✓ $m"; done
    for m in "${pushed_msgs[@]}"; do echo "  ↑ $m"; done
    for m in "${push_notes[@]}"; do echo "  ! $m"; done
  else
    if [[ $is_git_root == 1 ]]; then
      [[ ${1:-0} == 1 ]] && echo "  nothing to commit or push" || echo "  nothing to commit"
    else
      [[ ${1:-0} == 1 ]] && echo "  no changes or outgoing commits found in nested git repos" || echo "  no changes found in nested git repos"
    fi
  fi
}

unalias gg 2>/dev/null
function gg { g 1 }
