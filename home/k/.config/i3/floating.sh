#!/bin/bash
xprop -id $(xdotool getactivewindow) | grep FLOATING && i3-msg resize set 1024 720 && i3-msg move position center

