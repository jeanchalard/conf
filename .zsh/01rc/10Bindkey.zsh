#
# Bindkey setup
#

bindkey "[A" history-beginning-search-backward	# Up arrow
bindkey "[B" history-beginning-search-forward	# Down arrow
bindkey "" backward-delete-word	# Ctrl-Backspace
bindkey "[1;5C" forward-word		# Ctrl-Right
bindkey "[1;5D" backward-word		# Ctrl-Left
bindkey "[C" forward-word		# Alt-Right
bindkey "[D" backward-word		# Alt-Left
bindkey "[3~" delete-char		# Delete
bindkey "[F" end-of-line		# End
bindkey "[H" beginning-of-line	# Home
bindkey "í" menu-select		# Alt-m
bindkey "OP" run-help		# F1
bindkey "[23~" run-help		# Shift-F1
bindkey "" copy-prev-shell-word # Ctrl-O
bindkey "Â®" insert-last-word # Alt-.
bindkey "
" accept-and-infer-next-history
