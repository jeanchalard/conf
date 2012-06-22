function pocketize()
{
  if [ "" != "$2" ]
  then
    name="$2"
  else
    echo 'Name ?'
    read name
  fi
  if [[ -f $name ]]; then echo "File $name exists, go get stuffed."; else
    /usr/bin/mencoder -o $name $1 -oac faac -faacopts mpeg=4:object=2:raw:br=128 -ovc lavc -of lavf -lavfopts format=mp4 -lavcopts vcodec=mpeg4:vbitrate=140:aglobal=1:vglobal=1 -vf scale=640:-2
  fi
}
