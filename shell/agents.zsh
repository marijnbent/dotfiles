function add-agents {
  local pack=$1
  local src="${DOTFILES}/agents/skills/${pack}"

  if [[ -z $pack ]]; then
    echo "Available packs:"
    for d in "${DOTFILES}/agents/skills"/*/; do
      [[ -d $d ]] && echo "  $(basename "$d")"
    done
    return 0
  fi

  if [[ ! -d $src ]]; then
    echo "No pack found: ${pack}"
    return 1
  fi

  local count=0
  for dest in ".agents/skills" ".claude/agents"; do
    mkdir -p "$dest"
    for f in "$src"/*.md; do
      [[ -f $f ]] || continue
      ln -sf "$f" "$dest/$(basename "$f")"
      (( count++ ))
    done
  done

  echo "Linked $(( count / 2 )) agent(s) from 'skills/${pack}' → .agents/skills/ + .claude/agents/"
}

_add_agents_completion() {
  local -a packs
  packs=($(ls -d "${DOTFILES}/agents/skills"/*/ 2>/dev/null | xargs -I{} basename {}))
  _describe 'pack' packs
}
if (( $+functions[compdef] )); then
  compdef _add_agents_completion add-agents
else
  _agents_defer_compdef() {
    compdef _add_agents_completion add-agents
    precmd_functions=("${(@)precmd_functions:#_agents_defer_compdef}")
  }
  precmd_functions+=(_agents_defer_compdef)
fi
