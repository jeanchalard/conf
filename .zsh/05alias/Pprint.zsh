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
