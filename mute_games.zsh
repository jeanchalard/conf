#!/usr/bin/zsh

pactl list sink-inputs | grep --color=never 'Sink Input #\|application.name =' | grep --color=never -B 1 'DSPGAME.exe\|Genshin\|Planet Crafter\|Ixion\|SOULCALIBUR\|FTL.amd64\|Frostpunk\|Factorio\|FactoryGame\|GRIS' | grep \# | cut -d \# -f 2 | while read i; do pactl set-sink-input-mute $i toggle; done
