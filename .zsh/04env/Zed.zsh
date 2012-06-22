bindkey -N zed main
bindkey -A main zed-normal-keymap
bindkey -M zed '^x^w' accept-line
bindkey -M zed '^M' self-insert-unmeta
bindkey -M zed "\e[A" up-line-or-history
bindkey -M zed "\e[B" down-line-or-history
