kwrite_bin=`which kwrite`
function kwrite {
  $kwrite_bin $@ >& /dev/null
}
