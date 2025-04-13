#!/usr/bin/zsh

result=$(qdbus org.j.Daemon /org/j/Daemon/ScreenSaver org.j.Daemon.ScreenSaver.ToggleInhibit)
msg="Screen off : $result"
echo $msg
kdialog --passivepopup $msg 2
