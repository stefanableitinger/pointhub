#!/bin/bash

declare -a dont_lock_on=(
	"mpv"
	"Stremio"
)

export prevent_lock=0

for i in "${dont_lock_on[@]}"; do
	#echo "$i"
	#xdotool search --onlyvisible --name "$i"
	#xdotool search --onlyvisible --name "$i" | wc -l
	if [[ $(xdotool search --onlyvisible --name "$i" | wc -l) -gt 0 ]]; then 
		prevent_lock=$(($prevent_lock+1))
	fi
done

#echo "$prevent_lock"

if [[ $prevent_lock -eq 0 ]]; then
	#/bin/notify-send "locking screen"
	/usr/local/bin/slock
	#echo "locked"
#else
#	/bin/notify-send "prevented locking screen"
#	echo "not locked"
fi

