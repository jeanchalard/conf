#/usr/bin/zsh

pactl set-sink-mute alsa_output.usb-Generic_USB_Audio-00.HiFi__Speaker__sink toggle && if [ "false" = `pamixer --sink alsa_output.usb-Generic_USB_Audio-00.HiFi__Speaker__sink --get-mute` ]; then qdbus org.kde.plasmashell /org/kde/osdService showText "audio-on" "Audio on"; else qdbus org.kde.plasmashell /org/kde/osdService showText "audio-off" "Audio off"; fi
