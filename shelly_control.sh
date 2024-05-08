#! /bin/bash

# custom script that controls shelly plug and limits daily usage time 
# created by stefan ableitinger

# use cron to call script eg every 10 minutes:
# m h  dom mon dow   comman
# */10 * * * * shelly_control.sh

# debug flag
#set -x

# define custom settings
time_file="shelly_control.time"
log_file="shelly_control.log"
shelly_ip="192.168.0.3"
ini_credentials="admin:admin@"

# check login
if [ "$(curl $shelly_ip/meter/0 -s)" == "401 Unauthorized" ]; then
	if [ "$(curl $ini_credentials$shelly_ip/meter/0 -s)" == "401 Unauthorized" ]; then
		bash -c "echo $(date '+%Y-%m-%d %H:%M:%S') login_denied | tee -a $log_file"
		exit
	else
		login="$ini_credentials"
	fi
else
	login=""
fi

# set minutes since last script call from time file
if [ -f "$time_file" ]; then
	file_timestamp=$(bash -c "date -r $time_file +%s")
	curr_timestamp=$(date +%s)
	minutes_since_last=$(((time_file_unix_timestamp - cur_time_unix_timestamp)/60))

	# daily reset
	if ! [ "$(date -r $time_file +%F)" == "$(date +%F)" ]; then
		# remove login
		if [ "$login" == "$ini_credentials" ]; then
			bash -c "curl --data 'enabled=false' $login$shelly_ip/settings/login -s"
			login=""
		fi
		# remove time file
		bash -c "rm $time_file"
		bash -c "echo $(date '+%Y-%m-%d %H:%M:%S') daily_reset weekday_nr=$weekday_nr time=$ini_time | tee -a $log_file"
	fi
else
	minutes_since_last=0
fi

# weekday time ini values eg friday, saturday double time
weekday_nr=$(date "+%u")
case $weekday_nr in
	5|6)
		ini_time=240;;
	*)
		ini_time=120;;
esac

# get remaining time or create time_file with initial value
if [ -f "$time_file" ]; then
	remaining_time=$(bash -c "cat $time_file")
else
	remaining_time="$ini_time"
fi

# get current power consumption
power=$(bash -c "curl $login$shelly_ip/meter/0 -s | jq '.power'"); 

# power is on 
if [ $(echo "$power > 0" | bc -l) -eq 1 ]; then 
	# overridden do nothing
	if [ "$remaining_time" == "-2" ]; then
		exit
	fi
	
	# if power is supposed to be off force shutdown and enable password protection
	if [ "$remaining_time" == "-1" ]; then
		password=$(echo $ini_credentials | cut -d ":" -f2 - | cut -d "@" -f1)
		bash -c "curl --data 'password=$password&enabled=true' $login$shelly_ip/settings/login -s"
		bash -c "echo $(date '+%Y-%m-%d %H:%M:%S') force_shutdown | tee -a $log_file"
		force_shutdown="true"
		remaining_time=-2
	else
		remaining_time=$((remaining_time - minutes_since_last))
		if [ $(echo "$remaining_time < 0" | bc -l) -eq 1 ]; then
			remaining_time=0
		fi

		force_shutdown="false"
	fi

	# turn off when remaining minutes in counter is equal to 0
	if [ "$force_shutdown" == "false" ] && [ $(echo "$remaining_time == 1" | bc -l) -eq 1 ]; then 
		bash -c "curl --data 'turn=off' $login$shelly_ip/relay/0 -s"
		bash -c "echo $(date '+%Y-%m-%d %H:%M:%S') shutdown | tee -a $log_file"
		remaining_time=-1
	fi
			
	bash -c "echo $remaining_time | tee $time_file"
	bash -c "echo $(date '+%Y-%m-%d %H:%M:%S') current usage $power wph, $remaining_time minutes remaining, every $cron_fq minutes | tee -a $log_file"
fi
