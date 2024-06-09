#!/bin/bash
video=$1
duration=$(ffprobe -i $video -show_entries format=duration -v quiet -of csv="p=0")
factor=$(printf "%.5f" $(echo "($duration - 0.1) / 11" | bc -l))
for screen in $(seq 0 11); do
	ss=$(printf "%.5f" $(echo "$screen * $factor" | bc))
	ffmpeg -ss $ss -i $video -vframes 1 -f image2 screen_$screen.png -loglevel quiet
done
montage screen_{0,1,2,3}.png -tile 4x1 -geometry 300x175+0+0 row_1.png
montage screen_{4,5,6,7}.png -tile 4x1 -geometry 300x175+0+0 row_2.png
montage screen_{8,9,10,11}.png -tile 4x1 -geometry 300x175+0+0 row_3.png
montage row_1.png row_2.png row_3.png -tile 1x3 -geometry 1313x190+0+0 $video.png
rm -f screen_{0,1,2,3,4,5,6,7,8,9,10,11}.png
rm -f row_{1,2,3}.png
