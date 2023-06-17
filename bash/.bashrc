# Pieter's custom Aliases
alias nv='nvim'
alias vim='nvim'
alias php="$(~/.dotfiles/setphp.sh)"
alias artisan="php artisan"
alias art="artisan"
alias ls="ls -a"
alias g="git"
alias vimdiff='nvim -d'

# Assuming that if it is not linux that we are using git bash on windows with XAMPP
if [ $(uname -s) != 'Linux' ]; then
    alias php74='C:/xampp/php74/php.exe'
    alias php7='C:/xampp/php74/php.exe'
    alias php8='C:/xampp/php/php.exe'
    alias php81='C:/xampp/php/php.exe'
    alias nvim='"C:/Program Files/Neovim/bin/nvim.exe"'
fi
