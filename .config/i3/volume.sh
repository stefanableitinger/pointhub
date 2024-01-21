#!/bin/sh
#dunstctl close-all;

#icon_path="/usr/share/icons/Adwaita/symbolic/status/"
icon_path="/usr/share/icons/"
default_sink=$(pactl get-default-sink)

# restart if pulseaudio seems dead
if [ "$default_sink" != "alsa_output.pci-0000_00_1f.3.hdmi-stereo" ]; then
	pulseaudio -k
fi

if [ "$1" = "up" ]; then
	pactl set-sink-volume 0 +5%
elif [ "$1" = "down" ]; then
	pactl set-sink-volume 0 -5%
elif [ "$1" = "mute" ]; then
	pactl set-sink-mute 0 toggle
fi

svol=$(pactl get-sink-volume 0)
vper=$(echo "$svol" | awk '{ print $5 }' | sed "s/%//g")
muted=$(pactl get-sink-mute 0)

if [ "$vper" -gt 100 ]; then
	# reset if trying to go past 100% volume
	if [ "$1" = "up" ]; then
		pactl set-sink-volume 0 100%
	fi
	vper=100
fi

# choose icon according to volume level
if [ "$vper" -eq 0 ]; then
	icon=$icon_path"audio-volume-muted-symbolic.svg"
elif [ "$vper" -lt 40 ]; then
	icon=$icon_path"audio-volume-low-symbolic.svg"
elif [ "$vper" -lt 76 ]; then
	icon=$icon_path"audio-volume-medium-symbolic.svg"
elif [ "$vper" -gt 75 ]; then
	icon=$icon_path"audio-volume-high-symbolic.svg"
fi

if [ "$1" = "mute" ]; then
	msg="volume unmuted"
else
	msg="volume $1 "$vper"%"
fi

# if volume is muted always show muted volume icon
if [ "$muted" = "Mute: yes" ]; then
	icon=$icon_path"audio-volume-muted-symbolic.svg"
	if [ "$1" = "mute" ]; then
		msg="volume muted"
	fi
fi

dunstify --icon=$icon --hints int:value:$vper --hints string:hlcolor:#888888 --replace 1337 "$msg"

