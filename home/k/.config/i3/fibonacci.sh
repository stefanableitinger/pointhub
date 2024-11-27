#!/bin/bash

curdesktop=$(xdotool get_desktop)
cntwindowscurdesktop=$(xdotool search --all --onlyvisible --desktop "$curdesktop" --name "" | awk '{ print "xprop -id "$1 " | grep FLOATING | wc -l"}' | bash | grep 0 | wc -l)

if [ $cntwindowscurdesktop -le 1 ];
then
	i3-msg split h;
else
	i3-msg split toggle;
fi
