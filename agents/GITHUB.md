# GitHub Agent Rules

## CLI

Use the `gh` command for all GitHub operations — do not construct API URLs manually.

```sh
gh pr create
gh pr list
gh issue create
gh issue list
gh repo view
gh run list
gh run view <id>
```

## Commits

- Stage specific files by name, never `git add -A` or `git add .`
- Write commit messages that explain **why**, not what
- Keep the subject line under 72 characters
- Use present tense: "add feature" not "added feature"
- Never amend published commits — create a new one
- Never skip hooks (`--no-verify`)

## Branches

- Branch off `main` unless told otherwise
- Use lowercase kebab-case: `feature/short-description`
- Delete branches after merging

## Pull Requests

- Keep the title short (under 70 characters)
- Include a short summary and a test plan in the body
- Use `gh pr create` with a HEREDOC body for correct formatting
- Never force-push to `main`

## Safety

- Never run destructive git commands without explicit user confirmation:
  `git reset --hard`, `git push --force`, `git checkout .`, `git clean -f`
- Never commit secrets or `.env` files
- Do not push unless the user explicitly asks
