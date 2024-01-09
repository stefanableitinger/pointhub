if [ $(whoami) = 'root' ]; then
        PS1="\[\033[7;31m\][\u@\h]\[\033[0;37m\] \[\033[1;37m\][\w]\[\033[0;37m\] "
else
        PS1="\[\033[7;37m\][\u@\h]\[\033[0;37m\] \[\033[1;37m\][\w]\[\033[0;37m\] "
fi

alias xq='xbps-query -Rs '
alias xi='sudo xbps-install '
alias xr='sudo xbps-remove -Ry '
alias clock='tty-clock -s -c -D -C 7'
alias zzz='sudo ethtool -s enp1s0 wol g && sudo zzz'
alias shellypc='curl --data "turn=toggle" shellypc/relay/0'
alias shellytv='curl --data "turn=toggle" shellytv/relay/0'
alias iii="dbus-run-session xinit /bin/i3 -- /etc/X11/xinit/xserverrc :0 vt1 -keeptty -auth "'$(mktemp -p /tmp serverauth.XXXXXXXXXX)'
alias kde="xinit /bin/startplasma-x11 -- /etc/X11/xinit/xserverrc :0 vt1 -keeptty -auth "'$(mktemp -p /tmp serverauth.XXXXXXXXXX)'
alias gnm="xinit /bin/gnome-session -- /etc/X11/xinit/xserverrc :0 vt1 -keeptty -auth "'$(mktemp -p /tmp serverauth.XXXXXXXXXX)'
alias ll='ls --color -lh'
alias oe1="mpv http://ors-sn04.ors-shoutcast.at/oe1-q1a < /dev/null > /dev/null 2>&1 &"
alias oe1_="mpv http://ors-sn04.ors-shoutcast.at/oe1-q1a"
alias 247='mpv https://stream19.expo-media.eu/radio/9000 < /dev/null > /dev/null 2>&1 &'
alias 247_='mpv https://stream19.expo-media.eu/radio/9000'
alias shellytv="curl --data 'turn=toggle' 192.168.0.3/relay/0"
alias shellypc="curl --data 'turn=toggle' 192.168.0.4/relay/0"
mnt() { sudo mkdir -p /mnt/"$1"; sudo mount /dev/"$1" /mnt/"$1"; cd /mnt/"$1"; ll -al; }
umt() { cd ~; sudo umount /mnt/"$1"; [ "$(ls -A /mnt/"$1")" ] && lsblk || sudo rm -rf /mnt/"$1";  }
opatrix() { picom --active-opacity 0.5 & cmatrix -C white && pkill picom; }

export HISTFILESIZE=
export HISTSIZE=
export EDITOR=nvim
export MANPAGER="less -R"
export GOOGLE_API_KEY="no"
export GOOGLE_DEFAULT_CLIENT_ID="no"
export GOOGLE_DEFAULT_CLIENT_SECRET="no"
export ANDROID_HOME="/home/k/Downloads/commandlinetools-linux-10406996_latest/cmdline-tools/bin"
export OPENAI_API_KEY="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"
