#!/bin/bash
convert -background black -fill white -font /usr/share/fonts/spacemono-nf/Space\ Mono\ Nerd\ Font\ Complete\ Mono.ttf -pointsize 17 -weight heavy -size 1920x1200 -gravity center label:$(echo -E $(sed 's/.\{150\}/&\\n/g' ~/Documents/pi.txt) | head -c 910) ~/Pictures/pi.png
