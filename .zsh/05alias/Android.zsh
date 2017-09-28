#CONF static [[ $HOST = *.corp.google.com ]]
function b() {
  setopt local_options sh_word_split
  mmm $@
}
function up() {
  repo upload --cbr
}
hash -d n=~/a/master/frameworks/base/core/java/android/net
