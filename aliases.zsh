# Shortcuts
alias reloadshell="source ~/.zshrc"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias ll="/opt/homebrew/opt/coreutils/libexec/gnubin/ls -AhlFo --color --group-directories-first"
alias '..'="cd .."
alias '...'="cd ../.."
alias speed='speedtest'

# Directories
alias dotfiles="cd $DOTFILES"
alias p="cd $HOME/Projects"
alias w="cd $HOME/Projects/wordproof"
alias s="cd $HOME/Sites"

# Laravel
alias a="php artisan"
alias am="php artisan migrate"
alias ar="php artisan migrate:rollback"

# Python
alias python="python3"
alias pip="pip3"
alias py="python3"
alias pe="conda activate"

# PHP
alias cfresh="rm -rf vendor/ composer.lock && composer i"

# JS
alias dev="npm run dev"

# SSH
alias screatorscatalogue='ssh forge@168.119.191.144'
alias sflower='ssh forge@49.12.191.235'
alias scloud='ssh marijn@34.90.95.253'
alias sc2='ssh marijn@35.223.167.247'

# Brew
alias bi="brew info"
alias bs="brew search"
alias bc="brew install"