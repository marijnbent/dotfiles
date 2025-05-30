# Shortcuts
alias reloadshell="source ~/.zshrc"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias ll="/opt/homebrew/opt/coreutils/libexec/gnubin/ls -AhlFo --color --group-directories-first"
alias '..'="cd .."
alias '...'="cd ../.."
alias speed='speedtest'
alias codi="code-insiders"

# Directories
alias dotfiles="code $DOTFILES"
alias dot="code $DOTFILES"
alias p="cd $HOME/Projects"
alias w="cd $HOME/Projects/wordproof"
alias s="cd $HOME/Sites"
alias icloud="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/"

# Laravel
alias a="php artisan"
alias am="php artisan migrate"
alias ar="php artisan migrate:rollback"

# Python
alias py="python"

# PHP
alias cfresh="rm -rf vendor/ composer.lock && composer i"

# JS
alias dev="npm run dev"

# SSH
alias screatorscatalogue='ssh forge@31.220.103.36'
alias sflower='ssh forge@49.12.191.235'
alias scloud='ssh marijn@34.90.95.253'
alias scloud2='ssh marijn@34.32.132.164'

alias sploi='ssh ploi@188.245.170.184'

alias sradxa='ssh root@192.168.1.93'

# Brew
alias bi="brew info"
alias bs="brew search"
alias ba="brew install"
alias bac="brew --cask install"
alias mysql="/opt/homebrew/opt/mysql@8.4/bin/mysql -u root"