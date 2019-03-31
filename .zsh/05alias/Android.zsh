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
hash -d net=~/a/master/frameworks/base/core/java/android/net
hash -d n=~/a/master/vendor/google/tools/NetGrapher
hash -d a=~/a
function al()
{
  adb logcat | grep -v 'vendor.qti\|ActivityManager\|Bluetooth\|bt_\|Obex\|ActivityThread\|a2dp\|A2dp\|Adapter\|libprocessgroup\|providers.contact\|ServiceManagement\|Contacts\|Avrcp\|Hearing\|MediaSession\|ContactLocale\|Headset\|BttOpp\|OMX\|StrictMode\|android.emai\|tombstoned\|LoadedApk\|dumpstate\|SurfaceFlinger\|hardware.health\|phone expire'
}

function cp()
{
    branch=shift
    repo=shift

    current=$(pwd)
    if [[ current == "*/aosp/*" ]]; then
        repo=${current/aosp/${repo-master}}
    elif [[ current == "*/master/*" ]]; then
        source=${current/master/${repo-aosp}}
    else
        print "Can't find current"
        return
    fi


    print repo start $branch
    print git fetch $source $branch
    print git cherry-pick FETCH_HEAD
}
