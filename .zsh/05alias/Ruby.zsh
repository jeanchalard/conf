#CONF static [[ "$ZSH_VERSION" > "4.2" ]]
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
