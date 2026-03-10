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
alias notes="cd ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Notes"

# Laravel
alias a="php artisan"
alias am="php artisan migrate"
alias ar="php artisan migrate:rollback"

#AI
alias cl="claude --dangerously-skip-permissions"
alias co="codex"
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
alias bac="brew --cask install"

alias mysql="/opt/homebrew/opt/mysql@8.4/bin/mysql -u root"

# Zed editor
alias zed='/Applications/Zed.app/Contents/MacOS/cli'

# File Operations
copy() { cat "$1" | pbcopy; }
