# Pieter's custom Aliases
alias nv='nvim'
alias setphp="~/.dotfiles/setphp.sh"
alias php="$(setphp)"
alias artisan="php artisan"
alias art="artisan"
alias g="git"

# Assuming that if it is not linux that we are using git bash on windows
if [ $(uname -s) != 'Linux' ]; then
    alias php74='C:/xampp/php74/php.exe'
    alias php7='C:/xampp/php74/php.exe'
    alias php8='C:/xampp/php/php.exe'
    alias php81='C:/xampp/php/php.exe'
    alias nvim='"C:/Program Files/Neovim/bin/nvim.exe"'
fi