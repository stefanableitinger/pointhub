#!/bin/sh
picom_process_id=$(pidof picom)
if [ -z $picom_process_id ]; then
	notify-send 'starting picom'
	picom --config ~/.config/picom/picom.conf &
else
	notify-send 'stopping picom'
   	pkill picom &
fi

