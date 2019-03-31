#CONF static which kdialog
popup() {
  timeout=${3-5}
  if [[ $2 != "" ]]
  then
    title=$1
    msg=$2
  else
    title='Notice'
    msg=$1
  fi
  kdialog --title $title --passivepopup $msg $timeout
}
statuspopup() {
  res=$?
  if [[ 0 = $res ]]
  then
    title=${1-Status}
    popup $title Success
  else
    title=${1-Status}
    popup $title Failure
  fi
  return $res
}
