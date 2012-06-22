methods () {
  ruby -e "$1.methods.sort.each {|p| puts p }"
}
