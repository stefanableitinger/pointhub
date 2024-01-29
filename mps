#!/bin/bash
VL=()
IL=()
PID=()
WID=()
POS=()
NL=()

MAX=3
LI=0

#set -x

for i in $(seq 1 "$MAX"); do
	PID[$i]="0"
	WID[$i]="0"
	POS[$i]="$i"
done


if [[ "$1" = "" ]]; then 
	searchpath="."
	if [[ "$VF" != "" ]]; then
		searchpath="$VF"
	fi
else
	searchpath="$1"
fi

if [[ "$2" = "" ]]; then 
	searchfile="*"
else
	searchfile="*$2*"
fi

IFS=
mapfile -t VL < <(find "$searchpath" -type f -iname "$searchfile" -a \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \) )
mapfile -t IL < <(xdotool search --onlyvisible --class mpv)
IFS='
'
VL=( $(shuf -e "${VL[@]}") )

echo "total files: ${#VL[@]}"
# echo "${VL[@]}"

if [[ "${#VL[@]}" -lt "$MAX" ]]; then
	MAX="${#VL[@]}"
fi

while [ 1 -eq 1 ]; do

	# start the mpv instances and get their process ids
	for i in $(seq 1 "$MAX"); do

		# get processid for instance and check is running
		process_id="${PID[$i]}"
		if [ "$process_id" -ne "0" ]; then
			if [ "$(ps -p $process_id | wc -l)" -ne "2" ]; then
				process_id=0
				PID[$i]="$process_id"
			fi
		fi

		# split list into parts
		VLI=""
		IC=0
		if [ "$process_id" -eq "0" ]; then
			# how many videos per queue
			VPQ=$(("${#VL[@]}"/"$MAX"))
			if [[ "$VPQ" -eq "0" ]]; then
				VPQ=1
			fi

			for x in $(seq "$LI" $(("$LI"+"$VPQ"))); do
				if [[ "${VL[$x]}" != "" ]]; then
					if [[ "$VLI" != "" ]]; then
						VLI="$VLI' '"
					fi
					VLI="$VLI${VL[$x]}"
					IC=$(($IC+1))
				fi
			done

			LI=$(($LI+$IC))
		fi
			
		# run the video and set properties 
		if ! [ "$VLI" = "" ]; then
			echo "playing $IC file(s) in window $i"
			#echo "'$VLI'"
			bash -c "mpv '$VLI' --mute=yes --start=96% --end=99% --auto-window-resize=no" < /dev/null > /dev/null 2>&1 &
			process_id=$!
			window_id=$(xdotool search --sync --pid $process_id)
			WID[$i]="$window_id"
			PID[$i]="$process_id"
			POS[$i]="$i"
		fi
		
		# make it float	
		if [[ "$process_id" -ne "0" ]]; then
			window_id="${WID[$i]}"
			if [[ "$window_id" -ne "0" ]]; then
				# check if window exists before checking if it floats
				# or just redirect errors to null
				is_floating="$(xprop -id $window_id 2>/dev/null | grep -i floating | wc -l)"
				if [[ "$is_floating" -ne "1" ]]; then
					bash -c "i3-msg [ id=$window_id ] floating enable, resize set 800 px 600 px, move position 1740 px $((35+($i-1)*460)) px" < /dev/null > /dev/null 2>&1 &
				fi
			fi
		fi
	done

	# count the mpv
	mapfile -t NL < <(xdotool search --onlyvisible --class mpv)
	
	# remove all from IL that are not not in the NL, they dont exist
	for ILI in $(seq 0 $(("${#IL[@]}"-1))); do
		CNT=0
		for NLI in $(seq 0 $(("${#NL[@]}"-1))); do
			if [ "${NL[$NLI]}" -eq "${IL[$ILI]}" ]; then
				CNT=$(($CNT+1))	
			fi
		done
		if [ "$CNT" -eq "0"  ]; then
			unset 'IL[ILI]'
			echo "unset"
		fi
	done

	# remove all from NL that are in IL, they should be ignored
	for NLI in $(seq 0 $(("${#NL[@]}"-1))); do
		for ILI in $(seq 0 $(("${#IL[@]}"-1))); do
			if [ "${NL[$NLI]}" == "${IL[$ILI]}" ]; then
				unset 'NL[NLI]'
			fi
		done
	done

	# exit the script if there is no mpv running anymore
	if [ "${#NL[@]}" -eq "0" ]; then
		exit
	fi

#	echo "${#IL[@]}"
#	echo "${#NL[@]}"
#	echo "${#PID[@]}"
#	echo "${#WID[@]}"
#	echo "${#POS[@]}"
	#sleep 1
done

