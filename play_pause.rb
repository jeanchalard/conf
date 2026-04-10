#!/usr/bin/ruby -w

dir = __dir__
command = ARGV[0]

file = File.new("/#{dir}/.play_pause_time", File::CREAT | File::RDWR)
time = file.gets.to_f
file.rewind
file.puts(Time.now.to_f.to_s)
file.close

diff = Time.now.to_f - time

puts "#{command} #{diff}"

def volume(d)
  `pactl set-sink-volume All #{d}`
  vol = `pamixer --sink All --get-volume`
  `qdbus org.kde.plasmashell /org/kde/osdService org.kde.osdService.volumeChanged #{vol}`
end


case command
when 'up'
  if diff < 2.0
    volume("+5%")
  else
    `playerctl -i Gwenview play-pause`
  end
when 'down'
  volume("-5%")
else raise "Unknown command"
end
