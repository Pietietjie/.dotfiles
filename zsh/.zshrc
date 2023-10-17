export ZSH="$HOME/.oh-my-zsh"
export dot="$HOME/.dotfiles"

composer_path=$(which composer.phar)
ZSH_THEME="robbyrussell"
HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode reminder  # just remind me to update when it's time
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"
VI_MODE_SET_CURSOR=true
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true

if [ ! -d "$ZSH/custom/plugins/artisan" ]; then 
    git clone https://github.com/jessarcher/zsh-artisan.git ~/.oh-my-zsh/custom/plugins/artisan
fi

if [ ! -d "$ZSH/custom/plugins/zsh-autosuggestions" ]; then 
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [ ! -d "$ZSH/custom/plugins/zsh-syntax-highlighting" ]; then 
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

plugins=(
    artisan
    npm
    composer
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    docker
    docker-compose
)

# plugin settings
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#a6ec99,bold"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

source $ZSH/oh-my-zsh.sh

# zsh history ignore
function zshaddhistory() {
  emulate -L zsh
  if ! [[ "$1" =~ "(^ |^cd|^\.\.|password)" ]] ; then
      print -sr -- "${1%%$'\n'}"
      fc -p
  else
      return 1
  fi
}
# Pieter's custom Aliases
alias tm='tmux'
alias nv='nvim'
alias vim='nvim'
alias cl='clear'
composer() { php $composer_path "$@" }
artisan () { if [ -f sail ] || [ -f vendor/bin/sail ]; then sail artisan "$@"; else php artisan "$@"; fi; }
alias a="artisan"
alias change="sudo update-alternatives --config"
alias cdump="composer dump-autoload -o"
alias tink="a tinker"
alias sail="[ -f sail ] && sh sail || sh vendor/bin/sail"
alias ls="ls -1A --group-directories-first --color=always"
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
alias doc="docker"
alias dc="docker-compose"

alias db:reset="artisan migrate:reset && artisan migrate --seed"
alias fresh="migrate:fresh"
alias migrate="artisan migrate"
alias refresh="artisan migrate:refresh"
alias rollback="artisan migrate:rollback"
alias seed="artisan db:seed"

function mkd() {
    mkdir -p "$@" && cd "$@"
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# update_dot="g dotfiles pl"
# "${update_dot}" &>/dev/null & disown;
