set-status() { return $1; }

zle-xterm-mouse() {
  local last_status=$?
  emulate -L zsh
  setopt extendedglob # for (#b)
  local bt mx my cy i buf

  read -k bt # mouse button, x, y reported after \e[M
  read -k mx
  read -k my
  if [[ $bt != "#" ]]; then
    # Process on release, but record the button on press.
    ZLE_MOUSE_BUTTON=$bt
    return 0
  fi

  (( my = #my - 32 ))
  (( mx = #mx - 32 ))

  print -n '\e[6n' # query cursor position
  while read -k i && [[ $i != R ]]; do buf+=$i; done

  local match mbegin mend
  [[ $buf = (#b)??(*)\;* ]] || return
  cy=$match[1]
  # we don't need cx

  local cur_prompt
  if [[ -n $PREBUFFER ]]; then
    cur_prompt=$PS2
    # decide wether we're at the PS2 or PS1 prompt
  else
    cur_prompt=$PS1
  fi
  if [[ -o promptsubst ]]; then
    cur_prompt=${(e)cur_prompt}
  else
    cur_prompt=$cur_prompt
  fi

  # remove visual effects:
  cur_prompt=${(S)cur_prompt//("%{"*"%}"|%[BbEuUsS])/}
  # restore the exit status in case $PS<n> relies on it
  set-status $last_status
  cur_prompt=${(%)cur_prompt}
  cur_prompt=${cur_prompt##*$'\n'}

  local -a pos # array holding the possible positions of
               # the mouse pointer
  local -i x=0 y=1 cursor=$((${#cur_prompt}+$CURSOR+1))
  local Y
  buf=$cur_prompt$BUFFER
  for ((i=1; i<=$#buf; i++)); do
    (( i == cursor )) && Y=$y
    case $buf[i] in
      ($'\n') # newline
        : ${pos[y]=$i}
        (( y++, x=0 ));;
      ($'\t') # tab advance til next tab stop
        (( x = x/8*8+8 ));;
      ([$'\0'-$'\037'$'\0200'-$'\0237'])
        # characters like ^M
        (( x += 2 ));;
        # may cause trouble if spanned on two lines but well...
      (*)
        (( x++ ));;
    esac
    (( x >= mx )) && : ${pos[y]=$i}
    (( x >= COLUMNS )) && (( x=0, y++ ))
  done
  : ${pos[y]=$i} ${Y:=$y}

  local mouse_CURSOR
  if ((my + Y - cy > y)); then
    mouse_CURSOR=$#BUFFER
  elif ((my + Y - cy < 1)); then
    mouse_CURSOR=0
  else
    mouse_CURSOR=$(($pos[my + Y - cy] - ${#cur_prompt} - 1))
  fi

  case $ZLE_MOUSE_BUTTON in
    (' ')
      # Button 1.  Move cursor.
      CURSOR=$mouse_CURSOR
    ;;

    ('!')
      # Button 2.  Insert selection at mouse cursor postion.
      BUFFER=$BUFFER[1,mouse_CURSOR]$CUTBUFFER$BUFFER[mouse_CURSOR+1,-1]
      (( CURSOR = $mouse_CURSOR + $#CUTBUFFER ))
    ;;

    ('"')
      # Button 3.  Copy from cursor to mouse to cutbuffer.
      killring=("$CUTBUFFER" "${(@)killring[1,-2]}")
      if (( mouse_CURSOR < CURSOR )); then
        CUTBUFFER=$BUFFER[mouse_CURSOR+1,CURSOR+1]
      else
        CUTBUFFER=$BUFFER[CURSOR+1,mouse_CURSOR+1]
      fi
    ;;
  esac
}

zle-toggle-mouse() {
  # If no prefix, toggle state.
  # If positive prefix, turn on.
  # If zero or negative prefix, turn off.

  # Allow this to be used as a normal function, too.
  if [[ -n $1 ]]; then
    local PREFIX=$1
  fi
  if (( $+PREFIX )); then
    if (( PREFIX > 0 )); then
      ZLE_USE_MOUSE=1
    else
      ZLE_USE_MOUSE=
    fi
  else
    if [[ -n $ZLE_USE_MOUSE ]]; then
      ZLE_USE_MOUSE=
    else
      ZLE_USE_MOUSE=1
    fi
  fi
  if [[ -n $WIDGET ]]; then
    # Zle is currently active.
    # Make sure it's turned on or off straight away if required.
    if [[ -n $ZLE_USE_MOUSE ]]; then
      print -n '\e[?1000h'
    else
      print -n '\e[?1000l'
    fi
  fi
}

if [[ $functions[precmd] != *ZLE_USE_MOUSE* ]]; then
  functions[precmd]+='
  [[ -n $ZLE_USE_MOUSE ]] && print -n '\''\e[?1000h'\'
fi
if [[ $functions[preexec] != *ZLE_USE_MOUSE* ]]; then
  functions[preexec]+='
  [[ -n $ZLE_USE_MOUSE ]] && print -n '\''\e[?1000l'\'
fi

zle -N zle-xterm-mouse
bindkey '\e[M' zle-xterm-mouse

zle -N zle-toggle-mouse
bindkey ';' zle-toggle-mouse

ZLE_USE_MOUSE=
