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
