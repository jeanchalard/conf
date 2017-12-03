SETUPDIR=$HOME/.zsh

# for folder in $Setup;
# do
#   for file in $folder/*;
#     do
#     if [ "`echo $file | grep -v disabled`" != "" ];
#     then
# 	if [ "`echo $file | grep -v no$MACHTYPE`" != "" ];
# 	then
#             . $file
# 	fi
#     fi
#   done
# done

#######################################################
## adddir
# $1 : Name of the directory to add to configuration
# $2 : Configuration file name
#######################################################
function conf_adddir()
{
    for file in $1/*~$1/functions
    do
      echo $file
      if [ "`echo $file | grep -v disabled | grep -v '~$'`" ]
      then
	  if [ -d "$file" ]
	  then
	      conf_adddir $file $2
	  else
	      if [ -f "$file" ]
	      then
		  dynamic=()
		  static=y
		  grep '^#CONF' $file |
		  while read line
		  do
		    case "$line[(w)2]" in
			"static")
			    echo "Evaluating $line[(w)3,(w)${(w)#line}]..."
			    eval $line[(w)3,(w)${(w)#line}] >& /dev/null
			    if [ "$?" != "0" ]
			    then
				echo "...Shall not be included"
				static=n
			    else
				echo "...Shall be included"
			    fi;;
			"dynamic")
			    dynamic[$((${#dynamic}+1))]="$line[(w)3,(w)${(w)#line}]"
			    echo "...Shall be executed if $line[(w)3,(w)${(w)#line}]"
			    ;;
			*) echo "...parse error : $line";;
		    esac
		  done
		  if [ "$static" = "y" ]
		  then
		      for line in $dynamic
			do
			echo "$line" >> $2
			echo 'if [ "$?" = "0" ]' >> $2
			echo "then" >> $2
		      done
		      cat $file | grep -v "^#CONF" >> $2
		      for line in $dynamic
			do
			echo "fi" >> $2
		      done
		  fi
	      fi
	  fi
      fi
    done
}

function redo_conf()
{
    tmpfile=.zshrc.new

    curpwd=`pwd`
    cd $HOME
    nlines=`grep -n '^# Automatic configuration mark' .zshrc | cut -d':' -f1`
    head -n $nlines .zshrc > $tmpfile
    conf_adddir $SETUPDIR $tmpfile

    mv .zshrc .zshrc.old
    mv $tmpfile .zshrc
    zcompile .zshrc
}

# Automatic configuration mark
#
# Which shell do I use ?
#

export SHELL=`which zsh`
export FPATH=$FPATH:$HOME/.zsh/functions

#
# Sanity of my environment
#
[[ -t 0 ]] && /bin/stty erase  "^H" intr  "^C" susp "^Z" dsusp "^Y" stop "^S" start "^Q" kill "^U"  >& /dev/null
bindkey -e
#
# Bindkey setup
#

bindkey "[A" history-beginning-search-backward	# Up arrow
bindkey "OA" history-beginning-search-backward	# Up arrow
bindkey "[B" history-beginning-search-forward	# Down arrow
bindkey "OB" history-beginning-search-forward	# Down arrow
bindkey "" history-incremental-pattern-search-backward # C-R
bindkey "" backward-delete-word	# Ctrl-Backspace
bindkey "[1;5C" forward-word		# Ctrl-Right
bindkey "[1;5D" backward-word		# Ctrl-Left
bindkey "[C" forward-word		# Alt-Right
bindkey "[D" backward-word		# Alt-Left
bindkey "[3~" delete-char		# Delete
bindkey "[7~" beginning-of-line       # Home
bindkey "[H" beginning-of-line	# Home
bindkey "[8~" end-of-line       # End
bindkey "[F" end-of-line		# End
bindkey "OP" run-help		# F1
bindkey "[23~" run-help		# Shift-F1
bindkey "" copy-prev-shell-word # Ctrl-O
bindkey "®" insert-last-word # Alt-.
bindkey "
" accept-and-infer-next-history
# Autoload, define the user widget and bind incremental-... on TAB.
autoload incremental-complete-word
zle -N incremental-complete-word
bindkey	i incremental-complete-word

# zed, THE editor
autoload zed

# zmv. THE real useful mv.
autoload zmv

# Nslookup, for the network. Deprecated, but I still use it.
autoload nslookup

# Pass args to commands when the arguments are too numerous
autoload zargs
# Module for listing completed words with colors and all
zmodload zsh/complist

# Compinit
autoload compinit
compinit -C .zcompdump
# Enumarate user dirs so that they are replaced by the prompt even if
# they are not directly named
: $userdirs
export LESS='--RAW-CONTROL-CHARS --tabs=8'
eval `lesspipe`
bindkey '^Xx' all-matches
zstyle ':completion:all-matches::::' completer _all_matches _complete
zstyle ':completion:all-matches:*' old-matches true
zstyle ':completion:all-matches:*' insert true
zle -C all-matches complete-word _generic

zstyle ':completion:*' auto-description 'specify: %d'

zstyle ':completion:*' auto-description 'specify: %d'

zstyle ':completion:*' format '%{[32m%}-=> %{[01m%}%d%{[0m%}'

zstyle ':completion:*' group-name ''

zstyle ':completion:*' insert-unambiguous true

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:processes' list-colors '=(#b)(?????)(#B)?????????????????????????????????([^ ]#/)#(#b)([^ /]#)*=00=01;31=01;33'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=** r:|=**'
zstyle ':completion:*' max-errors 1

zstyle ':completion:*' menu select=5
zstyle ':completion:*' menu select interactive

zstyle ':completion:*' original true

export FPATH=$HOME/.zsh/functions:$FPATH

zstyle ':completion:*' squeeze-slashes true

# Perform 'cd' on a directory name if no homonymous command is found
setopt auto_cd

# Automatically send SIGCONT on disown SIGHUPPED jobs
setopt auto_continue
# Automatically list choices on an ambiguous completion
setopt auto_list

# Remove automatically added chars on the command line if the next char logically implies it was wrong. Example : print {foo<TAB> inserts ',' and typing '}' removes it
setopt auto_param_keys
# Add a slash after a completed directory name
setopt auto_param_slash

# Output numbers in a more readable format
setopt c_bases
# Security against overwriting files with a redirection
unsetopt clobber
# Completion options
setopt complete_aliases
setopt complete_in_word

# Try to correct the spelling of commands, using dvorak examination
setopt correct

# Dvorak keyboard
setopt dvorak

# Perform = filename expansion
setopt equals

# Assume  '#', '~' and '^' as part of patterns for filename generation
setopt extended_glob
# Note the location of each command
setopt hash_cmds
# Whenever a command name is hashed, hash the directory containing it
setopt hash_dirs

# Avoid duplicating older command in the history
setopt hist_ignore_all_dups
# Write history in incremental append mode
setopt inc_append_history

# Expand whatever is after = with glob
setopt magic_equal_subst
setopt no_bg_nice

setopt numeric_globsort

setopt prompt_subst

# Don't cd ~ when I pushd
setopt no_pushd_to_home
# Perform a implicit 'pushd' on 'cd'
setopt auto_pushd
# Ignore duplicate directory stack entries
setopt pushd_ignore_dups
PROMPT='%{[01m[34m%}%n%{[0m%}@%{[34m%}%m%{[0m%} %{[01m%}%{[3%0(?,%(!,1,3),4)m%}%35<...<%~%{[0m%} %0(?,^_^,%{[31m%}%1(?,>_<,%139(?,^_^;,%130(?,>_<,%135(?,^_^;,>_<)))))%{[0m%} %{[0m%}'
PROMPT='%{[01m%}%{[3%0(?,%(!,1,3),4)m%}%35<...<%~%{[0m%} %0(?,^_^,%{[31m%}%1(?,>_<,%139(?,^_^;,%130(?,>_<,%135(?,^_^;,>_<)))))%{[0m%} %{[0m%}'
RPROMPT='%(?,,%{[01m%}%{[31m%}%139(?,Segmentation fault,%130(?,Interrupt,%138(?,Bus Error,%141(?,Broken pipe,Err %?))))%{[0m%} )%B%T%b'

          zle -C all-matches complete-word _generic
          bindkey '^Xa' all-matches
          zstyle ':completion:all-matches:*' old-matches only
          zstyle ':completion:all-matches::::' completer _all_matches

export PATH=$PATH:${HOME}/android/sdk/platform-tools

export EDITOR=emacs

alias e='ssh -p 42 chalar_j@ssh.epita.fr'
eget () {
        total=""
        while [ -n "$1" ]
        do
                total="$total chalar_j@ssh.epita.fr:$1"
                shift
        done
        total="$total ." 
        scp -P 42 `echo $total`
}
# History configuration
HISTSIZE=20000
HISTFILE=~/.zshhistory
SAVEHIST=20000
export HISTSIZE
export SAVEHIST
export WWW_HOME='www.google.com'
export LS_COLORS='ow=34;04:di=37:ln=01;37:pi=40;33:so=01;34:bd=40;33;01:cd=40;33;01:or=40;31;01:*.tar=33:*.tgz=33:*.arj=33:*.zip=33:*.gz=33:*.bz2=33:*.jpg=35:*.gif=35:*.bmp=35:*.pgm=35:*.pbm=35:*.ppm=35:*.tga=35:*.png=35:*.GIF=35:*.JPG=35:*.xbm=35:*.xpm=35:*.tif=35:*.mpg=01;35:*.avi=01;35'
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
# My reader
export READNULLCMD=less
export TERM=xterm

yay()
{
  echo '    _         _'
  echo "_./' '\-._.-/' '\-._"
}
bindkey -N zed main
bindkey -A main zed-normal-keymap
bindkey -M zed '^x^w' accept-line
bindkey -M zed '^M' self-insert-unmeta
bindkey -M zed "\e[A" up-line-or-history
bindkey -M zed "\e[B" down-line-or-history
bindkey -M zed "OA" up-line-or-history
bindkey -M zed "OB" down-line-or-history
export ZLS_COLORS='ow=34;04:di=37:ln=01;37:pi=40;33:so=01;34:bd=40;33;01:cd=40;33;01:or=40;31;01:*.tar=33:*.tgz=33:*.arj=33:*.zip=33:*.gz=33:*.bz2=33:*.jpg=35:*.gif=35:*.bmp=35:*.pgm=35:*.pbm=35:*.ppm=35:*.tga=35:*.png=35:*.GIF=35:*.JPG=35:*.xbm=35:*.xpm=35:*.tif=35:*.mpg=01;35:*.avi=01;35'
alias cal='ncal -M -b'

alias 'cd..'='builtin cd ..'
alias -- '-'='cd -'
cd () {
        if [[ ${1[$(($#1-1)),$#1]} = '/l' && ! -d $1 ]]
        then
                builtin cd ${1%%/l}
                ls -l
        else
                if [[ ! -d $1 && -f $1 ]]
                then
                        builtin cd `dirname $1`
                else
                        builtin cd $@
                fi
        fi
}
alias clean="find . \( -name '*~' -o -name '.*~' -o -name '#*\#' -o -name 'a.out' \) -print -exec rm -f {} \;"
alias cleanall="find ~ \( -name '*~' -o -name '.*~' -o -name '#*\#' -o -name 'a.out' \) -print -exec rm -f {} \;"
typeset -A COLORNAMES
COLORNAMES=(red 31 green 32 yellow 33 blue 34 magenta 35 cyan 36 cream 37 none 0 white 39 bold 1)
export COLORNAMES

function cgrep()
{
  local color line nocolor

  color=31
  line=""
  nocolor="0"
  while [[ $# > 0 ]]; do
      if [[ "$1" = "-t" ]] || [[ "$1" = "--color" ]]; then
	  shift
	  if [[ "${COLORNAMES[$1]}" = "" ]]; then
	      color=$1
	  else
	      color=${COLORNAMES[$1]}
	  fi
      elif [[ "$1" = "+t" ]] || [[ "$1" = "--nocolor" ]]; then
	  nocolor="1"
      else
	  line="$line $1"
      fi
      shift
  done

  if [[ "$nocolor" = "1" ]]; then
      \grep ${=line}
  else
      GREP_COLOR="$color" \grep --color=always ${=line}
  fi
}
colorize()
{
        sed "s/$2/[$1m$2[0m/g"
}
alias cp=cp -i --reply=query

function get()
{
    rsync -r --links --bwlimit=2000 --partial --progress --rsh=ssh 192.168.0.2:$1 .
}
alias commit='git commit -a'
alias push='git push origin master'
log()
{
  git log --oneline --decorate $@
}

alias e='iconv -f EUC-JISX0213 -t utf-8'
alias s='iconv -f SHIFT_JISX0213 -t utf-8'
alias irb='irb --readline -r irb/completion'
alias kb='xkbcomp -I${HOME}/.xkb ~/.xkb/j.xkb $DISPLAY'
alias less='less -ir'
if [[ `ls --color >& /dev/null ; print $?` == 0 ]]
then
  alias l='ls -l --color'
  alias la='ls -la --color'
else
  alias l='ls -l'
  alias la='ls -la'
fi
alias md=mkdir

exec-me2() {
  /usr/wvgs/lib/scripts/me2/me2.fcgi h=${=@}
}

alias -s me2=exec-me2
methods () {
  ruby -e "$1.methods.sort.each {|p| puts p }"
}
hash -d www=/usr/wvgs/web
hash -d mws=/usr/wvgs/web/MWS
hash -d scripts=/usr/wvgs/lib/scripts/
hash -d ms=/usr/wvgs/lib/scripts/MWS
hash -d me2=/usr/wvgs/lib/scripts/me2
hash -d reg=/usr/wvgs/lib/scripts/register
hash -d reglib=/usr/wvgs/lib/register

allservers()
{
  coproc for i in mws{000..011} mjp208 mjp209 mws{21..25} mws{100..106} mws{300..311}; do ssh $i print \`uname -n\` \`${=@}\` &; done && cat <&p
}
alias news='emacs -f gnus'
alias new='emacs -f gnus'
function pocketize()
{
  if [ "" != "$2" ]
  then
    name="$2"
  else
    echo 'Name ?'
    read name
  fi
  if [[ -f $name ]]; then echo "File $name exists, go get stuffed."; else
    /usr/bin/mencoder -o $name $1 -oac faac -faacopts mpeg=4:object=2:raw:br=128 -ovc lavc -of lavf -lavfopts format=mp4 -lavcopts vcodec=mpeg4:vbitrate=140:aglobal=1:vglobal=1 -vf scale=640:-2
  fi
}
# Default "pprint" style
zstyle ":pprint:*" attr none
zstyle ":pprint:*" fgcolor default
zstyle ":pprint:*" bgcolor default
zstyle ":pprint:*" pad none
zstyle ":pprint:*" width ""
zstyle ":pprint:*" prestr ""
zstyle ":pprint:*" posstr ""
zstyle ":pprint:*" fillchar ""
zstyle ":pprint:*" newline yes
zstyle ":pprint:*" rawmode no

# "pprint" style for saying things catching attention
zstyle ":pprint:say:*" attr bold
zstyle ":pprint:say:*" fgcolor yellow

# "pprint" style for warnings
zstyle ":pprint:warning:*" fgcolor yellow
zstyle ":pprint:warning:*" prestr "* "

# "pprint" style for errors
zstyle ":pprint:error:*" attr bold
zstyle ":pprint:error:*" fgcolor red
zstyle ":pprint:error:*" prestr "*** "

# "pprint" style for debug strings
zstyle ":pprint:debug:*" prestr "! "
zstyle ":pprint:debug:*" fgcolor cyan
zstyle ":pprint:debug:*" newline yes
zstyle ":pprint:debug:*" rawmode yes

# "pprint" style for about-to-begin actions
zstyle ":pprint:action:*" attr bold
zstyle ":pprint:action:*" fgcolor blue
zstyle ":pprint:action:*" pad right
zstyle ":pprint:action:*" width '$COLUMNS-${#:-"[*]"}'
zstyle ":pprint:action:*" posstr "  "
zstyle ":pprint:action:*" newline no

# "pprint" style for status markers
zstyle ":pprint:status:*" prestr "[*]"
zstyle ":pprint:status:*" attr bold
zstyle ":pprint:status:success:*" fgcolor green
zstyle ":pprint:status:ignored:*" fgcolor black
zstyle ":pprint:status:failure:*" fgcolor red


# The usage is "pprint <style>"
function pprint() {

   emulate -LR zsh

   local _attr _fgcolor _bgcolor
   local _pad _width
   local _prestr _posstr _fillchar
   local _newline _rawmode

   for _style_element in attr fgcolor bgcolor\
                         pad width\
                         prestr posstr fillchar\
                         newline rawmode
   do
       eval zstyle -s ":pprint:$1:" $_style_element _$_style_element
   done

   ((#)) && shift

   # The "_width" element may depend on other variables, like $COLUMNS
   eval "_width=\$(( $_width ))"

   #   If the length of the prestring and the poststring is greater
   # than the number of available columns, then get rid of both.
   [[ $_width -gt 0 && $(( $#_prestr + $#_posstr )) -ge $_width ]] && {
       _prestr=""
       _posstr=""
   }

   if [[ "$_rawmode" == "y" ]]
   then _rawmode="-r"
   else _rawmode=""
   fi

   [[ -t 1 ]] && print -n -- "$attr[$_attr]$fg[$_fgcolor]$bg[$_bgcolor]"

   # If the especified width is empty or 0, then we don't do truncation
   _string="$*"
   (( _width )) && {
       (( _width -= ( $#_prestr + $#_posstr ) ))
       case $_pad[1] in
       n)
           eval _string="\"\${\${(pr:$_width::$_fillchar[1]::\0:)_string}%\$'\0'*}\""
           ;;
       r|l)
           eval _string="\"\${($_pad[1]:$_width::$_fillchar[1]:)_string}\""
           ;;
       esac
   }
   print $_rawmode -n -- "$_prestr$_string$_posstr"

   [[ -t 1 ]] && print -n -- "$bg[default]$fg[default]$attr[none]"

   [[ "$_newline[1]" == "y" ]] && print

   return 0
}
function put()
{
    rsync -r --links --bwlimit=2000 --partial --progress --rsh=ssh $1 192.168.0.2:$2
}
alias randomize="ruby -e 'a = ARGV; while not a.empty? do i = rand * a.size; puts a[i]; a -= [a[i]] end'"
alias rm=rm -i

exec-rb () {
  # Collect matches in local array files.  There might
  # be more than one match in $path.
  local -a files
  # This is a very common trick in zsh for searching paths.
  # ${^path}/$1 becomes $path[1]/$1 $path[2]/$1 ...
  # i.e. trial matches that might or might not be real files.
  # The (N) qualifier removes any elements that don't correspond to files.
  files=(${^path}/$1(N))
  # If we found a file, replace $1 by the path to the first match,
  # i.e. the earliest in the $path.
  # If we didn't find the file in path, leave the arguments alone.
  # A simpler version would be:
  #   (( ${#files} )) && 1=$files[1]
  (( ${#files} )) && set -- $files[1] "${(@)argv[2,-1]}"
  # Execute ruby with the original command line except with
  # $1 replaced as above.
  ruby "$@"
}
# Use the function instead of python for .py files.
alias -s rb=exec-rb
alias screen='screen -e  -xR '
alias ssu='su -'
wcp()
{
    dest=$@[-1]
    source=$@[1,-2]
    machine=${dest%%:*}
    dir=${dest##*:}

    if [[ '' = ${dest//[^:]/} ]]
    then
	scp -r $source $dest
	return
    fi

    sourcedir=''
    mkdir -p /tmp/wcp
    sourcedir=`mktemp /tmp/wcp/XXXXXXXX`
    rm -f $sourcedir
    mkdir -p $sourcedir
    scp -r ${=source} $sourcedir
    cd $sourcedir

    tar -czf - {*,.*}(N) | ssh $machine sudo -u wvgs tar -C $dir -xzf -

    cd -
    rm -rf $sourcedir
}
compdef wcp=scp

alias x='exit'

