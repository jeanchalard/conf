#
# Sanity of my environment
#
# Default to emacs editing mode, as opposed to vi
bindkey -e
# Remove the idiotic "break your input with ^S, restore with ^Q" behavior
/bin/stty stop "" start ""
unset flow_control

