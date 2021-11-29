#!/bin/bash
#loadkeys de
#wifi-menu
#pacman -Syu sudo curl

sudo pacman -Sy wget git neovim xorg-xinit base-devel rofi i3-gaps
sudo useradd k -m
sudo usermod -aG wheel,audio k

mkdir --parents /home/k/.local/share/fonts/spacemono-nf
curl --silent --output ~/.local/share/fonts/spacemono-nf/Space\ Mono\ Nerd\ Font\ Complete\ Mono.ttf https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/SpaceMono/Regular/complete/Space%20Mono%20Nerd%20Font%20Complete%20Mono.ttf
#put font on my github and get from there
fc-cache -rf /home/k/.local/share/fonts/spacemono-nf

mkdir -p /home/k/Downloads
cd /home/k/Downloads/

curl -Os https://dl.suckless.org/st/st-0.8.4.tar.gz
bsdtar -xpf st-0.8.4.tar.gz
cd st-0.8.4

curl -Os https://st.suckless.org/patches/scrollback/st-scrollback-0.8.4.diff
patch -p1 < st-scrollback-0.8.4.diff

sed -i "s\Liberation Mono:pixelsize=12\SpaceMono Nerd Font Mono:pixelsize=15\g" config.def.h
sudo make clean install

