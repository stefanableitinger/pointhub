#!/bin/bash

#setup sdcard

#sudo -s
#fdisk /dev/sda
#[p]-[o]-[n]-[p]-[enter]-[enter]-[+200M]-(if "Partition #1 contains a vfat signature." [y])-[t]-[c]-[n]-[p]-[enter]-[enter]-[enter]-(if "Partition #2 contains a ext4 signature." [y])-[w]
#mkfs.vfat /dev/sda1
#mkfs.ext4 /dev/sda2
#mkdir boot root
#mount /dev/sda1 boot
#mount /dev/sda2 root
#wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz
#bsdtar -xpf ArchLinuxARM-rpi-aarch64-latest.tar.gz -C root
#sync
#mv root/boot/* boot
#sed -i 's/mmcblk0/mmcblk1/g' root/etc/fstab
#curl -so root/root/setup.sh https://raw.githubusercontent.com/stefanableitinger/pointhub/master/setup.sh
#umount boot root

#boot and login root/root

#loadkeys de
#pacman-key --init
#pacman-key --populate archlinuxarm
#date -s "YYYY-MM-DD HH:MM:SS"
#wifi-menu
#pacman -Syu sudo curl neovim
#EDITOR=nvim visudo
#useradd -m k
#usermod -aG wheel,audio k
#cp setup.sh /home/k/
#chown k:k /home/k/setup.sh
#chmod +x /home/k/setup.s#cp setup.sh /home/k/
#chown k:k /home/k/setup.sh
#chmod +x /home/k/setup.shh
#passwd
#passwd k
#su k

sudo pacman -Sy xorg xorg-xinit base-devel rofi i3-gaps --noconfirm
mkdir -p /home/k/.local/share/fonts/spacemono-nf
curl -so /home/k/.local/share/fonts/spacemono-nf/Space\ Mono\ Nerd\ Font\ Complete\ Mono.ttf https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/SpaceMono/Regular/complete/Space%20Mono%20Nerd%20Font%20Complete%20Mono.ttf
#put font on my github and get from there
fc-cache -rf /home/k/.local/share/fonts/spacemono-nf
mkdir -p /home/k/Downloads
curl -s -O --output-dir /home/k/Downloads/ https://dl.suckless.org/st/st-0.8.4.tar.gz
bsdtar -xpf /home/k/Downloads/st-0.8.4.tar.gz -C /home/k/Downloads/
curl -so /home/k/Downloads/st-0.8.4/st-scrollback-0.8.4.diff https://st.suckless.org/patches/scrollback/st-scrollback-0.8.4.diff
cd /home/k/Downloads/st-0.8.4
patch -p1 < st-scrollback-0.8.4.diff
sed -i 's/Liberation Mono:pixelsize=12/SpaceMono Nerd Font Mono:pixelsize=15/g' config.def.h
sudo make clean install
head /etc/X11/xinit/xinitrc --lines=50 > /home/k/.xinitrc
echo "exec i3" >> /home/k/.xinitrc
