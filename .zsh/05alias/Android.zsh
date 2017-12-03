#CONF static [[ $HOST = *.corp.google.com ]]
function b()
{
  setopt local_options sh_word_split
  mmm $@
}
function up()
{
  repo upload --cbr
}
function sync()
{
  repo sync -c -j50
}
function sc() {
  img=$1
  if [[ "" = $img ]]; then print "Syntax : sc <filename>"; return; fi
  adb shell screencap -p /sdcard/${img}
  adb pull /sdcard/${img} .
  adb shell rm /sdcard/${img}
}
hash -d n=~/a/master/frameworks/base/core/java/android/net
