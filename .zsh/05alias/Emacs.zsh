e() {
  args=$@
  if [[ $#args == 0 ]]; then emacs; return; fi
  # Remove : and :\d+: at the end of the filenames so as to easily
  # copy paste the output of grep
  for i in {1..$#args}
  do
    args[$i]=${args[i]%:*(<0-9>):}
    args[$i]=${args[i]%:}
  done
  emacs ${=args}
}

