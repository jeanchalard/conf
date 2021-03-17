#CONF static [[ $HOST = *.corp.google.com || $HOST = *.googlers.com ]]
function b()
{
  setopt local_options sh_word_split
  mmm $@
}
function up()
{
  repo upload --cbr .
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
hash -d fb=~/a/aosp/frameworks/base
hash -d fln=~/a/aosp/frameworks/libs/net
hash -d ns=~/a/aosp/packages/modules/NetworkStack
hash -d wifi=~/a/aosp/packages/modules/Wifi
hash -d cs=~/a/aosp/frameworks/base/services/core/java/com/android/server
hash -d n=~/a/master/vendor/google/tools/NetGrapher
hash -d aosp=~/a/aosp
hash -d master=~/a/master
function al()
{
  adb logcat | grep -v 'vendor.qti\|ActivityManager\|Bluetooth\|bt_\|Obex\|ActivityThread\|a2dp\|A2dp\|Adapter\|libprocessgroup\|providers.contact\|ServiceManagement\|Contacts\|Avrcp\|Hearing\|MediaSession\|ContactLocale\|Headset\|BttOpp\|OMX\|StrictMode\|android.emai\|tombstoned\|LoadedApk\|dumpstate\|SurfaceFlinger\|hardware.health\|phone expire'
}

# Cherry-pick from another local repo.
function cpm()
{
    if [[ $1 == "" ]]; then
      print "Usage: $0 <dir>"
      return
    fi
    set -x
    current=$(readlink -f $(pwd))
    source=/mnt/ssd/$1/${current#/mnt/ssd/*/}

    cd $source
    destBranch=$(git branch --show-current)
    cd $current

    print "git fetch $source $branch"
    git fetch $source $branch
    print "git cherry-pick -x FETCH_HEAD"
    git cherry-pick -x FETCH_HEAD
    set +x
}
