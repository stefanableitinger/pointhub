#!/bin/bash

## prompt
if [ $(whoami) = 'root' ]; then
        PS1="\[\033[7;31m\][\u@\h]\[\033[0;37m\] \[\033[1;37m\][\w]\[\033[0;37m\] "
else
        PS1="\[\033[7;37m\][\u@\h]\[\033[0;37m\] \[\033[1;37m\][\w]\[\033[0;37m\] "
fi

## alias
alias xq='xbps-query -Rs '
alias xi='sudo xbps-install '
alias xr='sudo xbps-remove -Ry '
alias ll='ls --color --group-directories-first -lh -S'
alias lla='ls --color --group-directories-first -lh -A -S'
alias llh='ls --color --group-directories-first -lhd -S .*'
alias clock='tty-clock -s -c -D -C 7'
alias zzz='sudo ethtool -s enp1s0 wol g && sudo zzz'
alias shellypc='curl --data "turn=toggle" shellypc/relay/0'
alias shellytv='curl --data "turn=toggle" shellytv/relay/0'
alias pico="[ -c /dev/ttyACM0 ] && ampy -p /dev/ttyACM0" #mpremote
alias xv='vimiv'

## wm
alias iii="dbus-run-session xinit /bin/i3 -- /etc/X11/xinit/xserverrc :0 vt1 -keeptty -auth "'$(mktemp -p /tmp serverauth.XXXXXXXXXX)'";"
alias iis="/usr/bin/sway -c /home/k/.config/sway/config -d 2>/home/k/.config/sway/log.txt;"
alias kde="xinit /bin/startplasma-x11 -- /etc/X11/xinit/xserverrc :0 vt1 -keeptty -auth "'$(mktemp -p /tmp serverauth.XXXXXXXXXX)'
alias gnm="xinit /bin/gnome-session -- /etc/X11/xinit/xserverrc :0 vt1 -keeptty -auth "'$(mktemp -p /tmp serverauth.XXXXXXXXXX)'

## functions
xfind() { echo "searching $1..."; if [[ "$2" != "" ]]; then dir="$2"; else dir="."; fi; readarray -t results < <(find "${dir}" -maxdepth 4 -iname "*$1*";); found="${#results[@]}"; lines=$(tput lines); if [ "$found" -ge "$lines" ]; then echo "found "$found" results, display(Y/n)?"; read -n 1 -s -r display; if [[ "$display" != "n" ]]; then printf "%s\n" "${results[@]}" | less --quit-at-eof --ignore-case --clear-screen; fi else printf "%s\n" "${results[@]}"; fi }
mnt() { mountpoint=$(udevil mount /dev/"$1"); if [ "$?" == "0" ]; then mountpoint=$(echo $mountpoint | sed 's/ at /|/g' | cut -d'|' -f2); echo "mounted at "$mountpoint; cd "$mountpoint"; ll -al; fi; }
umt() { cd ~; udevil unmount /dev/"$1"; udisksctl power-off -b /dev/"$1";  }
adbfs() { pid=$(pidof adbfs); if [[ $pid != "" ]]; then cd ~; sudo fusermount -u /media; else sudo /home/k/Downloads/adbfs-rootless/adbfs -o allow_other -o rescan /media && cd /media/storage/emulated/0/; ls --color -lh; fi; }
xw3m() { w3m -o auto_image=false -M http://duckduckgo.com/lite; }
safepath() { [ -d "$1" ] && export PATH="$PATH:$1"; }

alias oe1='mpv http://ors-sn04.ors-shoutcast.at/oe1-q1a < /dev/null > /dev/null 2>&1'
alias oe1_='mpv http://ors-sn04.ors-shoutcast.at/oe1-q1a'
alias fm4='mpv http://ors-sn04.ors-shoutcast.at/fm4-q1a < /dev/null > /dev/null 2>&1'
alias fm4_='mpv http://ors-sn04.ors-shoutcast.at/fm4-q1a'
alias 247='mpv https://stream19.expo-media.eu/radio/9000 < /dev/null > /dev/null 2>&1'
alias 247_='mpv https://stream19.expo-media.eu/radio/9000'

export HISTFILESIZE=
export HISTSIZE=
export EDITOR=nvim
export MANPAGER="less -R"
export GOOGLE_API_KEY="no"
export GOOGLE_DEFAULT_CLIENT_ID="no"
export GOOGLE_DEFAULT_CLIENT_SECRET="no"
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export AZURE_DEV_COLLECT_TELEMETRY=no
export XDG_RUNTIME_DIR="/run/user/$UID"

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
[ -f /usr/share/bash-completion/000_bash_completion_compat.bash ] && source /usr/share/bash-completion/000_bash_completion_compat.bash

safepath "$HOME/.dotnet/"
safepath "$HOME/.dotnet/tools/"
safepath "$HOME/.az/bin/"
safepath "$HOME/.local/bin"

## when autologin is faster than pam.d/system-login pam_dumb_runtime_dir.so add to /etc/rc.local
# printf "\033[28;1m=> prepare for dumb XDG runtime dir\033[0;37m\n"
# mkdir -p /run/user
# chown root:_seatd /run/user
# chmod 775 /run/user
mkdir -p ${XDG_RUNTIME_DIR}

## testing mitm proxy locally
#export http_proxy="http://localhost:8080"
#export https_proxy="http://localhost:8080"
#export no_proxy="localhost,127.0.0.1" 
