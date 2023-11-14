# Shortcuts
alias reloadshell="source $HOME/.zshrc"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias ll="/opt/homebrew/opt/coreutils/libexec/gnubin/ls -AhlFo --color --group-directories-first"
alias '..'="cd .."
alias '...'="cd ../.."

# Directories
alias dotfiles="cd $DOTFILES"
alias p="cd $HOME/Projects"
alias w="cd $HOME/Projects/wordproof"

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


