# vim:ft=zsh ts=2 sw=2 sts=2
function php_prompt_info(){
  [[ -n $(php -r 'echo PHP_VERSION;') ]] || return
  echo "${ZSH_THEME_PHP_VERSION_PROMPT_PREFIX=[}$(php -r 'echo PHP_VERSION;')${ZSH_THEME_PHP_VERSION_PROMPT_SUFFIX=]}"
}

local user_host="%B%(!.%F{#db4b4b}.%F{#7aa2f7})%n@%m%{$reset_color%}%F{#ff9e64}:%{$reset_color%}"

# Must use Powerline font, for \uE0A0 to render.
ZSH_THEME_GIT_PROMPT_PREFIX="%F{#bb9af7}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{#ffaf5f}±"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{#9ece6a}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_RUBY_PROMPT_PREFIX="%F{#ff8787}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"

PROMPT='
☦  ${user_host}%F{#9ece6a}%~%{$reset_color%}
╰─ $(git_prompt_info) 🕐 %F{#ff8787}%*%{$reset_color%}%F{#bb9af7}:%{$reset_color%}'

RPROMPT='$(ruby_prompt_info)'

VIRTUAL_ENV_DISABLE_PROMPT=0
ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX=" %F{#9ece6a}🐍 "
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_PHP_VERSION_PROMPT_PREFIX=" %F{#bb8af7}🐘 "
ZSH_THEME_PHP_VERSION_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_VIRTUALENV_PREFIX=$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX
ZSH_THEME_VIRTUALENV_SUFFIX=$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX

