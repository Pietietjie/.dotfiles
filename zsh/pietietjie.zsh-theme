# vim:ft=zsh ts=2 sw=2 sts=2
local user_host="%B%(!.%F{#db4b4b}.%F{#7aa2f7})%n@%m%{$reset_color%}%F{#ff9e64}:%{$reset_color%}"

# Must use Powerline font, for \uE0A0 to render.
ZSH_THEME_GIT_PROMPT_PREFIX="%F{#bb9af7}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{#ffaf5f} "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{#9ece6a}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_CODE_PROMPT_PREFIX="%F{#bb9af7}‹%{$reset_color%}"
ZSH_THEME_CODE_PROMPT_SUFFIX="%F{#bb9af7}›%{$reset_color%}"

PROMPT='
%(?.%F{#9ece6a}󰳉 .%F{#ff8787}󰻌 )%{$reset_color%} ${user_host}%F{#9ece6a}%~%{$reset_color%} %F{#bb9af7}‹%{%}%F{#bb9af7} $(php -r "echo PHP_VERSION;")%{%}/%F{#bb9af7} $(nvm current)%{%}%F{#bb9af7}›%{%}${virtualenv_prompt_info} %F{#ff8787} %*%{$reset_color%}
%(?.%F{#9ece6a}.%F{#ff8787})╰─%{$reset_color%} $([[ $(git_prompt_info | sed "s/\w//g") ]] && echo $(git_prompt_info) || echo "%F{#ff8787}\uE0A0  %{$reset_color%}") %F{#bb9af7}:%{$reset_color%} '
