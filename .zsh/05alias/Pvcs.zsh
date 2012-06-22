#CONF static [[ "$HOST" == akiko ]]
alias pvcsclient='cmdclient -user jchalard -pass charlotte -host coriza -install "/usr/local/pvcs/dimensions7_1/" -dbname intermediate -dbpass "" -sqlnet pcms -cmd'

pvcsinner()
{
  FILENAME=$2
  CMDCLIENT='cmdclient -user jchalard -pass charlotte -host coriza -install "/usr/local/pvcs/dimensions7_1/" -dbname intermediate -dbpass "" -sqlnet pcms -cmd'
  if [[ $FILENAME[1] != "/" ]]; then
      WS_FILENAME=`pwd`/$FILENAME
  fi
  WS_FILENAME=${WS_FILENAME##$ID_HOME/}
  WS_DIR=`pwd`
  WS_DIR=${WS_DIR##$ID_HOME/}/
  COMMAND=""
  case $1 in
      ci|checkin)
	  COMMAND="RI _ID: /filename="${WS_FILENAME//\//@\/}" /keep"
	  echo checkin $WS_FILENAME
	  eval $CMDCLIENT \"$COMMAND\"
	  dos2unix $FILENAME 2> /dev/null
	  ;;
      co|checkout|Co|Checkout)
	  COMMAND="EI _ID: /filename="${WS_FILENAME//\//@\/}" /overwrite"
	  echo checkout $WS_FILENAME
	  eval $CMDCLIENT \"$COMMAND\"
	  dos2unix $FILENAME 2> /dev/null
	  ;;
      action)
	  COMMAND="AI _ID: /filename="${WS_FILENAME//\//@\/}
	  echo action $WS_FILENAME
	  eval $CMDCLIENT \"$COMMAND\"
	  ;;
      get|Get)
	  COMMAND="FI _ID: /filename="${WS_FILENAME//\//@\/}" /overwrite"
	  echo get $WS_FILENAME
	  eval $CMDCLIENT \"$COMMAND\"
	  dos2unix $FILENAME 2> /dev/null
	  ;;
      update)
	  COMMAND="UI _ID: /filename="${WS_FILENAME//\//@\/}" /keep"
	  echo update $WS_FILENAME
	  eval $CMDCLIENT \"$COMMAND\"
	  ;;
      Update)
	  COMMAND="UI _ID: /filename="${WS_FILENAME//\//@\/}" /keep"
	  echo update $WS_FILENAME
	  eval $CMDCLIENT \"$COMMAND\"
	  COMMAND="AI _ID: /filename="${WS_FILENAME//\//@\/}
	  echo action $WS_FILENAME
	  eval $CMDCLIENT \"$COMMAND\"
	  echo action $WS_FILENAME
	  eval $CMDCLIENT \"$COMMAND\"
	  ;;
      diff)
	  COMMAND="FI _ID: /filename="${WS_FILENAME//\//@\/}" /overwrite /user_filename=@/tmp@/foo"
	  echo diff $WS_FILENAME
	  eval $CMDCLIENT \"$COMMAND\"
	  dos2unix $FILENAME 2> /dev/null
	  diff $2 /tmp/foo
	  rm -f /tmp/foo
	  ;;
      ls)
	  WS_FILENAME=${WS_FILENAME%/*}
	  COMMAND="LWSD "${WS_FILENAME//\//@\/}" /files /recursive"
	  eval $CMDCLIENT \"$COMMAND\" | sed 's/\\/\//g' |
	  while read line; do
	    case $line in
		*:) if [[ "ITEMS:" != $line ]]; then
		    currep=${${${line/\\/\/}%:}##$WS_DIR}
		    fi
		    ;;
		*) file="$currep"${line[82,-1]%%;*}
		    if [[ $currep != $file && $oldfile != $file ]]; then
			echo $file
			oldfile=$file
		    fi
		    ;;
	    esac
	  done
	  ;;
      dm)
          rm -f /tmp/foo
	  COMMAND='BC _ID_DM_$FILENAME /FILENAME=\"/tmp/foo\"'
	  eval $CMDCLIENT \"$COMMAND\"
	  chmod u+w /tmp/foo
	  kfmclient openURL /tmp/foo >& /dev/null
	  ;;
      acdm)
	  COMMAND='AC _ID_DM_$FILENAME'
	  eval $CMDCLIENT \"$COMMAND\"
	  ;;
  esac
}

pvcs()
{
  if [[ "" = "$2" && "ls" != "$1" ]]; then
      echo "Syntax : $0 [checkin|ci|checkout|co|get|update|diff|ls|dm|acdm] <file>"
      return 1
  fi
  action=$1
  shift
  pvcsinner $action $1
  while [ "" != "$2" ]
  do
    shift
    pvcsinner $action $1
  done
}
