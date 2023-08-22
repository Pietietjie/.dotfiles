export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode reminder  # just remind me to update when it's time
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"
VI_MODE_SET_CURSOR=true
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true

plugins=(
    artisan
    npm
    vi-mode
    git
    zsh-autosuggestions
)

# plugin settings
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#a6ec99,bold"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

source $ZSH/oh-my-zsh.sh

# Pieter's custom Aliases
alias tm='tmux'
alias nv='nvim'
alias vim='nvim'
setphp() { ~/.dotfiles/setphp.sh $@ ; }
php () { $(~/.dotfiles/setphp.sh) $@ ; }
alias a="php artisan"
alias cdump="composer dump-autoload -o"
alias tink="a tinker"
alias sail="[ -f sail ] && sh sail || sh vendor/bin/sail"
alias ls="ls -a"
alias g="git"
alias q="exit"
alias :q="exit"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"
alias home="cd ~"
alias vimdiff='nvim -d'
alias so="omz reload"

alias db:reset="php artisan migrate:reset && php artisan migrate --seed"
alias dusk="php artisan dusk"
alias fresh="php artisan migrate:fresh"
alias migrate="php artisan migrate"
alias refresh="php artisan migrate:refresh"
alias rollback="php artisan migrate:rollback"
alias seed="php artisan db:seed"

function mkd() {
    mkdir -p "$@" && cd "$@"
}

