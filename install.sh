#!/bin/sh
#script to automate setup

#software
sudo apt install zsh i3 feh xfce4-terminal rofi compton python unzip wget curl -y

#fonts
sudo mkdir -p /usr/share/fonts/truetype/anonymice/
sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/AnonymousPro.zip -P /usr/share/fonts/truetype/anonymice/
sudo unzip -u /usr/share/fonts/truetype/anonymice/AnonymousPro.zip -d /usr/share/fonts/truetype/anonymice/
sudo rm /usr/share/fonts/truetype/anonymice/AnonymousPro.zip

fc-cache -f

#pictures
sudo mkdir -p /usr/share/backgrounds/custom/

if [ ! -e "/usr/share/backgrounds/custom/innere-stadt-lockscreen.png" ];
then
    sudo curl -o /usr/share/backgrounds/custom/innere-stadt-lockscreen.png https://raw.githubusercontent.com/stefanableitinger/pointhub/master/innere-stadt-lockscreen.png
fi

if [ ! -e "/usr/share/backgrounds/custom/innere-stadt.png" ];
then
    sudo curl -o /usr/share/backgrounds/custom/innere-stadt.png https://raw.githubusercontent.com/stefanableitinger/pointhub/master/innere-stadt.png
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
curl -o ~/win10_20h2.p10k.zsh https://raw.githubusercontent.com/stefanableitinger/pointhub/master/win10_20h2.p10k.zsh -s
curl -o ~/kali.p10k.zsh https://raw.githubusercontent.com/stefanableitinger/pointhub/master/kali.p10k.zsh -s
curl -o ~/phone.p10k.zsh https://raw.githubusercontent.com/stefanableitinger/pointhub/master/phone.p10k.zsh -s
curl -o ~/smb.conf https://raw.githubusercontent.com/stefanableitinger/pointhub/master/smb.conf -s


