#CONF static [[ "$ZSH_VERSION" > "4.2" ]]
exec-me2() {
  /usr/wvgs/lib/scripts/me2/me2.fcgi h=${=@}
}

alias -s me2=exec-me2
