#
# Sanity of my environment
#
[[ -t 0 ]] && /bin/stty erase  "^H" intr  "^C" susp "^Z" dsusp "^Y" stop "^S" start "^Q" kill "^U"  >& /dev/null
export LC_ALL=en_US.UTF-8
bindkey -e
