#! /bin/bash

# custom script that controls shelly plug and limits daily usage time 
# created by stefan ableitinger

# use cron to call script repeatedly eg every 10 minutes:
# m h  dom mon dow   comman
# */10 * * * * shelly_control.sh

# debug flag
set -x

# define custom settings
time_file="shelly_control.time"
log_file="shelly_control.log"
shelly_ip="192.168.0.3"
locked_credentials="admin:u1wpa@"

# check login
if [ "$(curl $shelly_ip/meter/0 -s)" == "401 Unauthorized" ]; then
	if [ "$(curl $locked_credentials$shelly_ip/meter/0 -s)" == "401 Unauthorized" ]; then
		bash -c "echo $(date '+%Y-%m-%d %H:%M:%S') login_denied >> $log_file"
		exit
	else
		login="$locked_credentials"
	fi
else
	login=""
fi

# weekday time ini values eg friday, saturday double time
weekday_nr=$(date "+%u")
case $weekday_nr in
	5|6)
		ini_time=240;;
	*)
		ini_time=120;;
esac

# set minutes since last script call from time file
if [ -f "$time_file" ]; then
	file_timestamp=$(bash -c "date -r $time_file +%s")
	curr_timestamp=$(date +%s)
	minutes_since_last=$(((curr_timestamp - file_timestamp)/60))

	# daily reset
	if ! [ "$(date -r $time_file +%F)" == "$(date +%F)" ]; then
		# remove login
		if [ "$login" == "$locked_credentials" ]; then
			bash -c "curl --data 'enabled=false' $login$shelly_ip/settings/login -s" > /dev/null
			login=""
		fi
		# remove time file
		bash -c "rm $time_file"
		bash -c "echo $(date '+%Y-%m-%d %H:%M:%S') daily_reset weekday_nr=$weekday_nr time=$ini_time >> $log_file"
	fi
else
	minutes_since_last=0

	# remove login if no file exists
	if ! [ -f "$time_file" ] && [ "$login" == "$locked_credentials" ]; then
		bash -c "curl --data 'enabled=false' $login$shelly_ip/settings/login -s" > /dev/null
		login=""
	fi
fi

# get remaining time from time_file or use initial value
if [ -f "$time_file" ]; then
	remaining_time=$(bash -c "cat $time_file")
else
	remaining_time="$ini_time"
fi

# get current power consumption
power=$(bash -c "curl $login$shelly_ip/meter/0 -s | jq '.power'"); 

# power is on 
if [ $(echo "$power > 0" | bc -l) -eq 1 ]; then 
	case $remaining_time in
		-2)
			# override do nothing
			exit;;
		-1)
			password=$(echo $locked_credentials | cut -d ":" -f2 - | cut -d "@" -f1)
			bash -c "curl --data 'turn=off' $login$shelly_ip/relay/0 -s"
			bash -c "curl --data 'password=$password&enabled=true' $login$shelly_ip/settings/login -s"
			bash -c "echo $(date '+%Y-%m-%d %H:%M:%S') force_shutdown >> $log_file"
			force_shutdown="true"
			remaining_time=-2;;
		*)
			remaining_time=$((remaining_time - minutes_since_last))
			if [ $(echo "$remaining_time < 0" | bc -l) -eq 1 ]; then
				remaining_time=0
			fi
			force_shutdown="false";;
	esac

	# turn off when remaining minutes in counter is equal to 0
	if [ "$force_shutdown" == "false" ] && [ $(echo "$remaining_time == 0" | bc -l) -eq 1 ]; then 
		bash -c "curl --data 'turn=off' $login$shelly_ip/relay/0 -s"
		bash -c "echo $(date '+%Y-%m-%d %H:%M:%S') shutdown >> $log_file"
		remaining_time=-1
	fi
			
	bash -c "echo $remaining_time > $time_file"
	if [ $(echo "$remaining_time >= 0" | bc -l) -eq 1 ]; then
		bash -c "echo $(date '+%Y-%m-%d %H:%M:%S') current usage $power wph, $remaining_time minutes remaining >> $log_file"
	fi
fi
