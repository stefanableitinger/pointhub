#!/bin/bash

while true; 
do
	rec=$(ffprobe -loglevel quiet -hide_banner -select_streams v:0 -show_format -of default=noprint_wrappers=1 -print_format json -i http://live.radiolive247.ro/radio/8980 | jq ".format.tags.StreamTitle" | sed -e "s/ /_/g" | sed -e "s/\"//g" | sed -e "s/$/.mp3/g")
	crec=$rec

	echo $crec
	sleep 1

	#echo "ffmpeg -i http://live.radiolive247.ro/radio/8980/ -vn "$crec
	ffmpeg -i http://live.radiolive247.ro/radio/8980/ -vn $crec </dev/null >/dev/null 2>&1 &

	while [[ "$rec" = "$crec" ]] 
	do
		crec=$(ffprobe -loglevel quiet -hide_banner -select_streams v:0 -show_format -of default=noprint_wrappers=1 -print_format json -i http://live.radiolive247.ro/radio/8980 | jq ".format.tags.StreamTitle" | sed -e "s/ /_/g" | sed -e "s/\"//g" | sed -e "s/$/.mp3/g")
	
		sleep 1
		printf "."
	done
	printf "\n"
	ps wwwaux | grep -i "[f]fmpeg" | awk '{print "kill "$2}' | bash
done


