autoload vcs_info
zstyle ':vcs_info:*' enable git
# Must use the literal [0m to reset instead of %b to stop bg color and %f to stop fg color, because vcs_info overrides %b to be the branch name.
zstyle ':vcs_info:*' actionformats ' %f%K{166}!%k%F{red}%B%a%{[0m%}%K{166}!%k'
# My home is under git – which in hindsight might not be a great idea.
# I don't want a branch name whenever I'm in my home or anywhere under,
# and I'm willing to abandon showing the branch name when I am in a place
# where it would be useful. Maybe when my home is no longer under git
# but instead .conf or something is and home links there, this can be
# reactivated because it's pretty nice.
# zstyle ':vcs_info:*' formats '%k %K{113}%b'
# This always displays nothing (for some reason the empty string
# resolves to the literal 'a:', and %a replaces the action when
# format is only used when there is no action.
zstyle ':vcs_info:*' formats '%a'
functions[precmd]+='
vcs_info
'
