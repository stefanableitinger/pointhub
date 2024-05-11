#!/bin/bash
search_result_videos=()
video_cue=()

mpv_command_parameter="--mute=yes --start=97% --end=99% --auto-window-resize=no --loop-playlist=inf --video-aspect-override=1.77777777777777777777"
search_path="."
search_pattern="*"
number_of_players=1

# for debugging
#set -x

# set file separator for arrays to handle spaces in filenames
IFS="
"

# get base directory for videos from 2nd parameter, default is pwd
if ! [ "$2" == "" ]; then search_path="$2"; fi

# get search string for videos from 3rd parameter, default is any
if ! [ "$3" == "" ]; then search_pattern="*$3*"; fi

# create list of video files in random order
mapfile -t videos < <(find "$search_path" -type f -iname "$search_pattern" -a \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \) )
videos=( $(shuf -e "${videos[@]}") )

# get number of players on screen from 1st parameter but not more than video files, default is 1 player
if ! [ "$1" = "" ]; then
	if [ "$(echo "$1 > ${#videos[@]}" | bc -l)" -eq 1 ]; then number_of_players="${#videos[@]}"
	else number_of_players="$1"
	fi 
else number_of_players=1
fi

# initialize players paused for more than four
if [ "$number_of_players" -gt 4 ]; then mpv_command_parameter="$mpv_command_parameter --pause"; fi

# assign videos to players
count_videos_total=${#videos[@]}
count_videos_player=$(($count_videos_total / $number_of_players))
count_videos_extra=$(($count_videos_total - ($count_videos_player * $number_of_players)))
video_index_from=0
for player in $(seq 1 "$number_of_players"); do
	player_index=$(($player - 1))
	if [ "$player_index" == "0" ]; then
		video_index_from=0
		video_index_to=$(($count_videos_player + $count_videos_extra - 1))
	else
		video_index_from=$(($video_index_to + 1))
		video_index_to=$(($video_index_from + $count_videos_player - 1))
	fi
	video_cue=""
	for video_index in $(seq "$video_index_from" "$video_index_to"); do
		video_cue+="'${videos[$video_index]}' "
	done
	player_cue[$player_index]="$video_cue"
done

# start players and make them float
for player in $(seq 1 "$number_of_players"); do
	player_index=$(($player - 1))
	player_guid=$(uuidgen)
	bash -c "mpv $mpv_command_parameter ${player_cue[$player_index]} --input-ipc-server=/tmp/mps_player_index_$player_guid < /dev/null > /dev/null 2>&1 &"
	player_pid=$(ps wwwaux | grep -i "[m]pv.*mps_player_index_$player_guid" | awk '{print $2}')
	sleep 1
	player_window=$(xdotool search --pid "$player_pid")
	posy=$((30+($player_index)*475))
	if [ "$player" -le "3" ]; then posx=1750
	elif [ "$player" -le "6" ]; then posx=880; posy=$(($posy-1425))
	elif [ "$player" -le "9" ]; then posx=15; posy=$(($posy-2850))
	fi
	bash -c "i3-msg [ id=$player_window ] floating enable, resize set 800 px 400 px, move position $posx px $posy px" < /dev/null > /dev/null 2>&1 &
done
