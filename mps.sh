#!/bin/bash
search_result_videos=()
video_cue=()
player_windows=()

mpv_command_parameter="--pause --mute=yes --start=96% --end=99% --auto-window-resize=no --loop-playlist=inf --keepaspect-window=no"
search_path="/home/k/Videos/xyz/"
search_pattern="*"
number_of_players=4
floating="True"

# for debugging
#set -x

# set file separator for arrays to handle spaces in filenames
IFS="
"


if [ "$#" -eq 3 ]; then
	search_pattern="*$2*"
	search_path="$3"
elif [ "$#" -eq 2 ]; then
	search_path="$2"
elif [ "$#" -eq 1 ]; then
	if [ "$1" == "--help" ] || [ "$1" == "--h" ] || [ "$1" == "-help" ] || [ "$1" == "-h" ]; then
		echo "usage: mps"
		echo "1st parameter is the number of windows (if prefixed 'x' eg x1 then without floating mode)" 
		echo " 	if two parameters are provided"
		echo "		2nd parameter is path to search for videos"
		echo " 	if three parameters are provided"
		echo "		2nd parameter is search string"
		echo "		3rd parameter is path to search for videos that contain the search string"
		echo ""
		echo "without parameters defaults are used"
		echo "	number of floating windows: $number_of_players"
		echo "	search path: $search_path"
		echo "	search pattern: $search_pattern"
		exit
	fi
fi

# create list of video files in random order
mapfile -t videos < <(find "$search_path" -type f -iname "$search_pattern" -a \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \) )
videos=( $(shuf -e "${videos[@]}") )

if [ "$DISPLAY" = "" ]; then
	bash -c "mpv $mpv_command_parameter ${videos[@]}"
	exit
fi

# get number of players on screen from 1st parameter prefix x and windows are not floating
if [ ! "$1" = "" ]; then 
	if [[ "$1" == *"x"* ]]; then floating="False"; fi
	number_of_players=$(echo "$1" | cut -dx -f2)
fi

screen_width=$(xrandr | grep '*' | awk '{print $1}' | cut -dx -f1)
screen_height=$(xrandr | grep '*' | awk '{print $1}' | cut -dx -f2)

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
	player_window=$(xdotool search --sync --pid "$player_pid")
	player_windows+=("$player_window")

	case $number_of_players in
		1)
window_width=$(printf "%.0f" "$(echo "$screen_width - 20" | bc -l)")
			window_height=$(printf "%.0f" "$(echo "$screen_height - 40" | bc -l)")
			posx=10
			posy=30;;
		2)
			window_width=$(printf "%.0f" "$(echo "(($screen_width - 30) / 2)" | bc -l)")
			window_height=$(printf "%.0f" "$(echo "$screen_height - 40" | bc -l)")
			posx=$(printf "%.0f" "$(echo "$player_index * ($window_width + 10) + 10" | bc -l)")
			posy=30;;
		3)
			window_height=$(printf "%.0f" "$(echo "($screen_height - 50) / 2" | bc -l)")
			case $player in
				1)
					window_width=$(printf "%.0f" "$(echo "$screen_width - 20" | bc -l)")
					posx=10
					posy=30;;
				2)
					window_width=$(printf "%.0f" "$(echo "(($screen_width - 30) / 2)" | bc -l)")
	posx=10
					posy=$(printf "%.0f" "$(echo "$window_height + 40" | bc -l)");;
				3)
					window_width=$(printf "%.0f" "$(echo "(($screen_width - 30) / 2)" | bc -l)")
					posx=$(printf "%.0f" "$(echo "$window_width + 20" | bc -l)")
					posy=$(printf "%.0f" "$(echo "$window_height + 40" | bc -l)");;
			esac;;
		4)
			window_width=$(printf "%.0f" "$(echo "(($screen_width - 30) / 2)" | bc -l)")
			window_height=$(printf "%.0f" "$(echo "($screen_height - 50) / 2" | bc -l)")
			case $player in
				1|2)
					posy=30;;
				3|4)
					posy=$(printf "%.0f" "$(echo "$window_height + 40" | bc -l)");;
			esac
			case $player in
				1|3)
					posx=10;;
				2|4)
					posx=$(printf "%.0f" "$(echo "$window_width + 20" | bc -l)");;
			esac;;
	esac
	if [ "$floating" == "True" ]; then 
		i3-msg "[ id=$player_window ] floating enable, resize set $window_width px $window_height px, move position $posx px $posy px"
	fi
done

for player_window in "${player_windows[@]}"; do
	xdotool key --window "$player_window" space
done
