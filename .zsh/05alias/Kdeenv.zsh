#CONF static [[ "$USER" == j ]]
function kdeenv {
  export PATH="$PATH:$HOME/kde/src/kdesrc-build"
  function kdesrc-run
  {
    source "$HOME/kde/build/$1/prefix.sh" && "$HOME/kde/usr/bin/$@"
  }
}


