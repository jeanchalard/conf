#CONF static test -d $HOME/perso/backgrounds
cbg()
{
  if [ "$1" = "" ];
  then
    xv -root -quit -max `ra $HOME/perso/backgrounds/*`
  else
    xv -root -quit -max $1
  fi
  echo 1 >! $HOME/.bg
}
