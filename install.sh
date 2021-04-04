#!/bin/bash
#script to automate setup

if [ $(id -u) -ne 0 ];
  then printf "\n\033[1;34m[0]\033[m root permission required for setup"
       sudo echo ""
fi

#prepare setup
printf "\n\033[1;34m[1.0]\033[0m setup required packages (not optional)"
printf "\n\033[1;34m[1.1]\033[0m setup extra packages? ([y]/n)" 
read -p "" answer11
printf "\033[1;34m[1.2]\033[0m setup jail2ban? (y/[n])" 
read -p "" answer12
printf "\033[1;34m[2.0]\033[0m setup anonymice fonts? ([y]/n)" 
read -p "" answer20
printf "\033[1;34m[3.0]\033[0m copy images? (y/[n])" 
read -p "" answer30
printf "\033[1;34m[4.0]\033[0m setup zsh, plugins and config (not optional)"
printf "\n\033[1;34m[5.0]\033[0m copy config files? ([y]/n)" 
read -p "" answer50
printf "\033[1;34mstarting setup\033[0m"

#software
printf "\n\033[1;34m>> [1.0]\033[0m setup required packages"
printf "\n"
sudo apt install zsh git curl wget unzip python -y

if test ! "$answer11" = "n"
then
    printf "\n\033[1;34m>> [1.1]\033[0m setup extra packages"
    printf "\n"
    sudo apt install i3 xfce4-terminal rofi compton -y
    sudo apt install remmina nmap net-tools endlessh firejail -y
    sudo apt install feh asciiart cmatrix -y
else
    printf "\n\033[1;34m>> [1.1]\033[m skipping extra packages"
    printf "\n"
fi

if test "$answer12" = "y"
then
    printf "\n\033[1;34m>> [1.2]\033[m setup jail2ban"
    printf "\n"    
    sudo apt install jail2ban -y
else
    printf "\n\033[1;34m>> [1.2]\033[m skipping jail2ban"
    printf "\n"
fi

#fonts
if test ! "$answer20" = "n"
then
    printf "\n\033[1;34m>> [2.0]\033[m setup anonymice fonts"
    printf "\n"    
    sudo mkdir -p /usr/share/fonts/truetype/anonymice/
    sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/AnonymousPro.zip -P /usr/share/fonts/truetype/anonymice/
    sudo unzip -u /usr/share/fonts/truetype/anonymice/AnonymousPro.zip -d /usr/share/fonts/truetype/anonymice/
    sudo rm /usr/share/fonts/truetype/anonymice/AnonymousPro.zip
    fc-cache -f
else
    printf "\n\033[1;34m>> [2.0]\033[m skipping font packages"
    printf "\n"
fi

#pictures
if test "$answer30" = "y"
then
    printf "\n\033[1;34m>> [3.0]\033[m copy images"
    sudo mkdir -p /usr/share/backgrounds/custom/
    if [ ! -e "/usr/share/backgrounds/custom/innere-stadt-lockscreen.png" ];
    then
        sudo curl -o /usr/share/backgrounds/custom/innere-stadt-lockscreen.png https://raw.githubusercontent.com/stefanableitinger/pointhub/master/innere-stadt-lockscreen.png -s
    fi

    if [ ! -e "/usr/share/backgrounds/custom/innere-stadt.png" ];
    then
        sudo curl -o /usr/share/backgrounds/custom/innere-stadt.png https://raw.githubusercontent.com/stefanableitinger/pointhub/master/innere-stadt.png -s
    fi

    if [ ! -e "/usr/share/backgrounds/custom/ubuntu.png" ];
    then
        sudo curl -o /usr/share/backgrounds/custom/ubuntu.png https://raw.githubusercontent.com/stefanableitinger/pointhub/master/ubuntu.png -s
    fi

    if [ ! -e "~/k.png" ];
    then
        curl -o ~/k.png https://avatars.githubusercontent.com/u/56166006?s=460&u=90d8b9564b0c06ae16ea1b62e2b6b741fdf52842&v=4
    fi
else
    printf "\n\033[1;34m>> [3.0]\033[m skipping images"
fi

#setup zsh
printf "\n\033[1;34m>> [4.0]\033[m setup zsh, plugins and config"
if [ -e ~/.oh-my-zsh ];
then
    rm ~/.oh-my-zsh -rf
    unset ZSH
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone git://github.com/wting/autojump.git ~/.oh-my-zsh/custom/plugins/autojump

cd ~/.oh-my-zsh/custom/plugins/autojump/
python install.py

curl -o ~/.zshrc https://raw.githubusercontent.com/stefanableitinger/pointhub/master/.zshrc -s

if test ! "$answer50" = "n"
then
    printf "\n\033[1;34m>> [5.0]\033[m copy config files"
    curl -o ~/.config/i3/config https://raw.githubusercontent.com/stefanableitinger/pointhub/master/i3_config -s
    curl -o ~/.p10k.win.zsh https://raw.githubusercontent.com/stefanableitinger/pointhub/master/.p10k.win.zsh -s
    curl -o ~/.p10k.pi.zsh https://raw.githubusercontent.com/stefanableitinger/pointhub/master/.p10k.pi.zsh -s
    curl -o ~/.p10k.phone.zsh https://raw.githubusercontent.com/stefanableitinger/pointhub/master/.p10k.phone.zsh -s
    curl -o ~/smb.conf https://raw.githubusercontent.com/stefanableitinger/pointhub/master/smb.conf -s
    curl -o ~/termux.properties https://raw.githubusercontent.com/stefanableitinger/pointhub/master/termux.properties -s
else 
    printf "\n\033[1;34m>> [5.0]\033[m skipping config files"
fi

    printf "\n\033[1;34msetup complete\033[m "
    printf "\n"
