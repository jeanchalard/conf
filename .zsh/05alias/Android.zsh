#CONF static test [[ $HOST == *.corp.google.com ]]
b() {
  setopt local_options sh_word_split
  mmm $@
}

