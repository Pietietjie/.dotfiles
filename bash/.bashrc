# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export dot="$HOME/.dotfiles"
export EDITOR="nvim"

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

ps1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$\n'

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export FZF_DEFAULT_OPTS='
--border=rounded
--padding=0,1
--margin=4,10
--color=dark
--color=fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:#4b5263,hl+:#d858fe
--color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:#61afef,header:#61afef,gutter:-1,border:#1f2335
--bind=j:down,q:abort,k:up,v:toggle+down,ctrl-a:toggle-all
'

# Functions
dexe() {
  local container_id
  container_id=$(docker container ls | sed 1d | fzf | awk '{print $1}')

  if [ -z "$container_id" ]; then
    echo "No container selected or found."
    return 1
  fi

  local shell="${1:-bash}"

  echo "Executing '$shell' in container ID: $container_id"
  docker exec -it "$container_id" "$shell"
}

composer-link() {
    composer config minimum-stability dev
    local package
    package=$(echo $1 | sed -nr 's/.*\/([^\/]+)$/\1/p')
    composer config "repositories.$package" '{"type": "path", "url": "'$1'"}'
}

composer-github() {
    composer config minimum-stability dev
    local package
    package=$(echo $1 | sed -nr 's/.*\/(.*)\.git/\1/p')
    composer config "repositories.$package" vcs $1
}

if type "php" > /dev/null 2>&1; then
    composer_path=$(which composer)
    composer() { php $composer_path "$@"; }
    sailartisan() {
        if [ -f vendor/.dontsail ]; then
            php artisan "$@"
        elif [ -f sail ] || [ -f vendor/bin/sail ]; then
            sail artisan "$@"
        else
            php artisan "$@"
        fi
    }
    alias artisan="php artisan"
    alias a="artisan"
    alias aa="sailartisan"
    alias p="php"
    alias cdump="composer dump-autoload -o"
    alias sail="[ -f sail ] && sh sail || sh vendor/bin/sail"
    alias db:reset="artisan migrate:reset && artisan migrate --seed"
    alias fresh="migrate:fresh"
    alias migrate="artisan migrate"
    alias refresh="artisan migrate:refresh"
    alias rollback="artisan migrate:rollback"
    alias seed="artisan db:seed"
    alias tink="artisan tinker"
fi

# 1 Character Aliases
alias d="docker"
alias g="git"
alias q="exit"
# Remaining Aliases
alias kys="exit"
alias gs="git s"
alias ga="git a"
alias gch="git ch"
alias ls="ls -1A --group-directories-first --color=always"
alias :q="exit"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"
alias home="cd ~"
alias vimdiff='nvim -d'
alias so="source ~/.bashrc"
alias doc="docker"
alias dc="docker-compose"
alias tm='tmux'
alias nv='nvim'
alias cl='clear'
alias change="sudo update-alternatives --config"
alias fzcp="cp \$(fzf)"
alias fzmv="mv \$(fzf)"

# Assuming that if it is not linux that we are using git bash on windows with XAMPP
if [ $(uname -s) != 'Linux' ]; then
    composer() { previousdir=${pwd} ; cd "/c/Program Files/composer/" ; php ./composer.phar "$@" ; cd $previousdir ; }
    php74() { /c/xampp/php74/php.exe $@; }
    php7() { /c/xampp/php74/php.exe $@; }
    php8() { /c/xampp/php/php.exe $@; }
    php81() { /c/xampp/php/php.exe $@; }
    alias nvim='"C:/Program Files/Neovim/bin/nvim.exe"'
fi

# update_dot="g dotfiles pl"
# "${update_dot}" &>/dev/null & disown;

if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

if [[ -d "$HOME/.config/herd-lite/bin" ]]; then
    export PATH="$HOME/.config/herd-lite/bin:$PATH"
    export PHP_INI_SCAN_DIR="$HOME/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
fi

if type "go" > /dev/null 2>&1; then
    export PATH=$PATH:/usr/local/go/bin
    export PATH=$PATH:$(go env GOPATH)/bin
fi

export PATH="$HOME/.local/bin:$PATH"
