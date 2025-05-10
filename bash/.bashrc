# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

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
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# My custom Aliases
# Functions
composer() {
    php $composer_path "$@"
}
artisan() {
    if [ -f vendor/.dontsail ]; then
        php artisan "$@";
    elif [ -f sail ] || [ -f vendor/bin/sail ]; then
        sail artisan "$@"; else
        php artisan "$@";
    fi
}
composer-link() {
    composer config minimum-stability dev;
    local package=`echo $1 | sed -nr 's/.*\/([^\/]+)$/\1/p'`;
    composer config "repositories.$package" '{"type": "path", "url": "'$1'"}';
}
composer-github() {
    composer config minimum-stability dev;
    local package=`echo $1 | sed -nr 's/.*\/(.*)\.git/\1/p'`;
    composer config "repositories.$package" vcs $1;
}
# 1 Character Aliases
alias a="artisan"
alias d="docker"
alias g="git"
alias p="php"
alias q="exit"
# Remaining Aliases
alias kys="exit"
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
alias dexe="docker exec -it \$(docker container ls | sed 1d | fzf | awk '{print \$1}') bash"
alias fzcp="cp \$(fzf)"
alias fzmv="mv \$(fzf)"

artisan () { if [ -f sail ] || [ -f vendor/bin/sail ]; then sail artisan "$@"; else php artisan "$@"; fi; }

# Assuming that if it is not linux that we are using git bash on windows with XAMPP
if [ $(uname -s) != 'Linux' ]; then
    composer() { previousdir=${pwd} ; cd "/c/Program Files/composer/" ; php ./composer.phar "$@" ; cd $previousdir ; }
    php74() { /c/xampp/php74/php.exe $@; }
    php7() { /c/xampp/php74/php.exe $@; }
    php8() { /c/xampp/php/php.exe $@; }
    php81() { /c/xampp/php/php.exe $@; }
    alias nvim='"C:/Program Files/Neovim/bin/nvim.exe"'
fi

update_dot="g dotfiles pl"
"${update_dot}" &>/dev/null & disown;

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
