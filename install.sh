#!/bin/sh
#script to automate setup

sudo echo ""

#software
echo "setup required packages"
sudo apt install zsh git curl wget unzip python -y
sudo apt install i3 xfce4-terminal rofi compton -y

read -p "setup extra packages ([Y]/n)?" answer
if test ! "$answer" = "n"
then
    echo "installing extra packages"
    sudo apt install remmina nmap net-tools endlessh firejail -y
    sudo apt install feh asciiart cmatrix -y
else
    echo "skipping extra packages"
fi

read -p "setup jail2ban (y/[N])?" answer
if test "$answer" = "y"
then
    echo "installing jail2ban"
    sudo apt install jail2ban -y
else
    echo "skipping jail2ban"
fi

#fonts
read -p "setup anonymice fonts ([Y]/n)?" answer
if test ! "$answer" = "n"
then
    echo "installing anonymice fonts"
    sudo mkdir -p /usr/share/fonts/truetype/anonymice/
    sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/AnonymousPro.zip -P /usr/share/fonts/truetype/anonymice/
    sudo unzip -u /usr/share/fonts/truetype/anonymice/AnonymousPro.zip -d /usr/share/fonts/truetype/anonymice/
    sudo rm /usr/share/fonts/truetype/anonymice/AnonymousPro.zip
    fc-cache -f
else
    echo "skipping font packages"
fi

#pictures
read -p "copy images ([Y]/n)?" answer
if test ! "$answer" = "n"
then
    echo "copying images"
    sudo mkdir -p /usr/share/backgrounds/custom/
    if [ ! -e "/usr/share/backgrounds/custom/innere-stadt-lockscreen.png" ];
    then
        sudo curl -o /usr/share/backgrounds/custom/innere-stadt-lockscreen.png https://raw.githubusercontent.com/stefanableitinger/pointhub/master/innere-stadt-lockscreen.png
    fi

    if [ ! -e "/usr/share/backgrounds/custom/innere-stadt.png" ];
    then
        sudo curl -o /usr/share/backgrounds/custom/innere-stadt.png https://raw.githubusercontent.com/stefanableitinger/pointhub/master/innere-stadt.png
    fi

    if [ ! -e "~/k.png" ];
    then
        curl -o ~/k.png https://avatars.githubusercontent.com/u/56166006?s=460&u=90d8b9564b0c06ae16ea1b62e2b6b741fdf52842&v=4 -s
    fi
else
    echo "skipping images"
fi

#config
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
curl -o ~/.config/i3/config https://raw.githubusercontent.com/stefanableitinger/pointhub/master/i3_config -s
curl -o ~/win10_20h2.p10k.zsh https://raw.githubusercontent.com/stefanableitinger/pointhub/master/.p10k.win.zsh -s
curl -o ~/kali.p10k.zsh https://raw.githubusercontent.com/stefanableitinger/pointhub/master/.p10k.pi.zsh -s
curl -o ~/phone.p10k.zsh https://raw.githubusercontent.com/stefanableitinger/pointhub/master/.p10k.phone.zsh -s
curl -o ~/smb.conf https://raw.githubusercontent.com/stefanableitinger/pointhub/master/smb.conf -s

echo "setup complete"
