export ZSH="$HOME/.oh-my-zsh"
export dot="$HOME/.dotfiles"

composer_path=$(which composer.phar)
ZSH_THEME="af-magic"
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

export FZF_DEFAULT_OPTS='
--border=rounded
--padding=0,1
--margin=4,10
--color=dark
--color=fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:#4b5263,hl+:#d858fe
--color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:#61afef,header:#61afef,gutter:-1,border:#1f2335
'

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
# My custom Aliases
# Functions
composer() { php $composer_path "$@" }
artisan () { if [ -f vendor/.dontsail ]; then php artisan "$@"; elif [ -f sail ] || [ -f vendor/bin/sail ]; then sail artisan "$@"; else php artisan "$@"; fi; }
composer-link() { composer config minimum-stability dev; local package=`echo $1 | sed -nr 's/.*\/([^\/]+)$/\1/p'`; composer config "repositories.$package" '{"type": "path", "url": "'$1'"}'; }
composer-github() { composer config minimum-stability dev; local package=`echo $1 | sed -nr 's/.*\/(.*)\.git/\1/p'`; composer config "repositories.$package" vcs $1; }
# 1 Character Aliases
alias a="artisan"
alias d="docker"
alias g="git"
alias p="php"
alias q="exit"
# Remaining Aliases
alias gs="git s"
alias ga="git a"
alias gch="git ch"
alias ls="ls -1A --group-directories-first --color=always"
alias tink="a tinker"
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
alias tm='tmux'
alias nv='nvim'
alias vim='nvim'
alias cl='clear'
alias change="sudo update-alternatives --config"
alias cdump="composer dump-autoload -o"
alias sail="[ -f sail ] && sh sail || sh vendor/bin/sail"
alias db:reset="artisan migrate:reset && artisan migrate --seed"
alias fresh="migrate:fresh"
alias migrate="artisan migrate"
alias refresh="artisan migrate:refresh"
alias rollback="artisan migrate:rollback"
alias seed="artisan db:seed"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# update_dot="g dotfiles pl"
# "${update_dot}" &>/dev/null & disown;
