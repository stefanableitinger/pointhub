#!/bin/bash
search_result_videos=()
video_cue=()
player_windows=()

mpv_command_parameter="--pause --mute=yes -start=96% --end=100% --auto-window-resize=no --loop-playlist=inf --keepaspect-window=no"
search_path="/home/k/Videos/xyz"
search_pattern="*"
number_of_players=1
floating="True"

# for debugging
set -x

# set file separator for arrays to handle spaces in filenames
IFS="
"

if [ ! "$2" == "" ] && [ ! "$2" == "-" ]; then search_path="$2"; fi
if [ ! "$3" == "" ] && [ ! "$3" == "-" ]; then search_pattern=*"$3"*; fi

if [ "$#" -eq 1 ] && [ "$1" == "--help" ] || [ "$1" == "--h" ] || [ "$1" == "-help" ] || [ "$1" == "-h" ]; then
	echo "usage: mps [-]n path/- name/-"
	echo "	n defines number of windows, if prefixed with \"-\" the windows do not float"
	echo "	path defines path to search for videos when \"-\" is used the default path applies"
	echo "	name defines search string when \"-\" is used the default search string applies"
	echo ""
	echo "defaults are"
	echo "	number of floating windows: $number_of_players"
	echo "	search path: $search_path"
	echo "	search string: $search_pattern"
	exit
fi

# create list of video files in random order
mapfile -t videos < <(find "$search_path" -type f -iname "$search_pattern" -a \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" -o -iname "*.avi" \) )
videos=( $(shuf -e "${videos[@]}") )

echo ${#videos[@]}
echo ${videos[@]}

if [ "$DISPLAY" = "" ]; then
	bash -c "mpv $mpv_command_parameter ${videos[@]}"
	exit
fi

# get number of players on screen from 1st parameter prefix x and windows are not floating
if [ ! "$1" = "" ]; then 
	if [[ "$1" == "-"* ]]; then floating="False"; else floating="True"; fi
	number_of_players=$(echo "$1" | cut -d- -f2)
fi

#debug
params="number_of_players: $number_of_players
search path: $search_path
search string: $search_pattern
videos: ${videos[@]}"

#notify-send "$params" -w

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
done

for player in $(seq 1 "$number_of_players"); do
	player_index=$(($player - 1))
	player_window="${player_windows[$player_index]}"
	case $number_of_players in
		1)
			window_width=$(printf "%.0f" "$(echo "$screen_width - 20" | bc -l)")
			window_height=$(printf "%.0f" "$(echo "$screen_height - 40" | bc -l)")
			posx=10
			posy=30;;
		2)
			window_width=$(printf "%.0f" "$(echo "(($screen_width - 30) / 2)" | bc -l)")
			window_height=$(printf "%.0f" "$(echo "($screen_height / 2)" | bc -l)")
			posx=$(printf "%.0f" "$(echo "$player_index * ($window_width + 10) + 10" | bc -l)")
			posy=$(printf "%.0f" "$(echo "(($screen_height - $window_height) / 2) + 30" | bc -l)");;
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
		10)
			case $player in
				1)
					window_width=1265
					window_height=695
					posx=10
					posy=30;;
				2)
					window_width=630
					window_height=340
					posx=1285
					posy=30;;
				3)
					window_width=630
					window_height=345
					posx=1285
					posy=380;;
				4)
					window_width=630
					window_height=345
					posx=1925
					posy=30;;
				5)
					window_width=630
					window_height=345
					posx=1925
					posy=380;;
				6)
					window_width=630
					window_height=345
					posx=10
					posy=735;;
				7)
					window_width=630
					window_height=345
					posx=10
					posy=1090;;
				8)
					window_width=630
					window_height=345
					posx=645
					posy=735;;
				9)
					window_width=630
					window_height=345
					posx=645
					posy=1090;;
				10)
					window_width=1265
					window_height=695
					posx=1285
					posy=735;;
			esac;;

	esac
	if [ "$floating" == "True" ]; then 
		i3-msg "[ id=$player_window ] floating enable, resize set $window_width px $window_height px, move position $posx px $posy px" > /dev/null
	fi
done

for player_window in "${player_windows[@]}"; do
	xdotool key --window "$player_window" space
done
