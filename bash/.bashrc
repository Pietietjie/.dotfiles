# Pieter's custom Aliases
alias tm='tmux'
alias nv='nvim'
alias vim='nvim'
alias setphp="~/.dotfiles/setphp.sh"
alias php="$(~/.dotfiles/setphp.sh)"
alias artisan="php artisan"
alias art="artisan"
alias a="artisan"
alias tink="a tinker"
alias sail="[ -f sail ] && sh sail || sh vendor/bin/sail"
alias ls="ls -a"
alias g="git"
alias q="exit"
alias :q="exit"
alias ..="cd .."
alias vimdiff='nvim -d'

# Assuming that if it is not linux that we are using git bash on windows with XAMPP
if [ $(uname -s) != 'Linux' ]; then
    alias php74='C:/xampp/php74/php.exe'
    alias php7='C:/xampp/php74/php.exe'
    alias php8='C:/xampp/php/php.exe'
    alias php81='C:/xampp/php/php.exe'
    alias nvim='"C:/Program Files/Neovim/bin/nvim.exe"'
fi
