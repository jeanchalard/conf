#CONF static test "$USER" = "j"
cbg()
{
  if [ "$1" = "" ];
  then
    bg=`ra /backgrounds/*`
  else
    bg=$1
  fi
  dcop kdesktop KBackgroundIface setWallpaper $bg 4
  xv -root -quit -maxpect -rmode 5 $bg
  echo 1 >! $HOME/.bg
}
