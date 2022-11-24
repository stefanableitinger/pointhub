#!/bin/bash
cntWindows=$(xdotool search --all --onlyvisible --desktop $(xprop -notype -root _NET_CURRENT_DESKTOP | cut -c 24-) "" 2>/dev/null | wc -l)
#dunstctl close-all;
#notify-send "$cntWindows";

if [ $cntWindows -lt 2 ];
then
	i3-msg split h;
	#notify-send "set split horizontal";
#else
	#notify-send "nothing to do";
fi
