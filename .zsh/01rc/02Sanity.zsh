# Sanity of my environment
[[ -t 0 ]] && /bin/stty erase  "^H" intr  "^C" susp "^Z" dsusp "^Y" stop "^S" start "^Q" kill "^U"  >& /dev/null
# Default to emacs editing mode, as opposed to vi
bindkey -e
# Remove the idiotic "break your input with ^S, restore with ^Q" behavior
/bin/stty stop "" start ""
unset flow_control

