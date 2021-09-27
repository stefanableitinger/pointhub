#!/bin/sh
if pidof -x mplayer > /dev/null
then
  killall mplayer
else
  mplayer http://ors-sn04.ors-shoutcast.at/fm4-q1a </dev/null >/dev/null 2>&1 &
  #cava
fi

