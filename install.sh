#!/bin/sh
# author stefan ableitinger
# automatic friendly setup script

welcome () {
	
	printf "\033[1;34m             _                 _                 \033[m\n"
	printf "\033[1;34m  __ _ _   _| |_ ___  ___  ___| |_ _   _ _ __    \033[m\n"
	printf "\033[1;34m / _| | | | | __/ _ \/ __|/ _ \ __| | | | |_ \   \033[m\n"
	printf "\033[1;34m| |_| | |_| | || |_| \__ \  __/ |_| |_| | |_| |  \033[m\n"
	printf "\033[1;34m \__|_|\__|_|\__\___/|___/\___|\__|\__|_| |__/   \033[m\n"
	printf "\033[1;34m                                        |_|	   \033[m\n"
	printf "\033[1;34mby stefan ableitinger                            \033[m\n"
	printf "\n"
	}

readOne () {
        oldstty=$(stty -g)
        stty -icanon -echo min 1 time 0
        result=$(dd bs=1 count=1 2>/dev/null)
        stty "$oldstty"
        }

zshSetup () {		
		if [ -e ~/.oh-my-zsh ];
		then
			rm ~/.oh-my-zsh -rf
			unset ZSH
		fi
		
		cd ~

		# oh-my-zsh
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
		
		# plugins
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
		git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
		git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
		git clone git://github.com/wting/autojump.git ~/.oh-my-zsh/custom/plugins/autojump

		cd ~/.oh-my-zsh/custom/plugins/autojump/
		python install.py

		# config
		curl -o ~/.zshrc https://raw.githubusercontent.com/stefanableitinger/pointhub/master/.zshrc
		curl -o ~/.p10k.zsh https://raw.githubusercontent.com/stefanableitinger/pointhub/master/.p10k.zsh					
		}

yesOrQuit () {
		while true; do
				readOne
				case $result in
						[yY]* )
								break;;
						[qQ]* )
								printf "bye\n"
								exit;;
						* )
								;;
				esac
		done					
		}

debianSetup () {
		printf "\033[1;34m[1]\033[0m setup contains required packages for oh-my-zsh with p10k (curl git python zsh).\n"
		printf "\033[1;34m[2]\033[0m setup packages for i3 windowmanager (compton feh i3-gaps mugshot rofi xfce4-terminal)? press [y]es/[n]o or [q]uit.\n"
		
		while true; do
                readOne
                case $result in
                        [yY]* )
                                dc2="yes"
								break;;
                        [nN]* )
                                dc2="no"
								break;;
                        [qQ]* )
                                printf "bye\n"
                                exit;;
                        * )
                                ;;
                esac
        done
		
		printf "\033[1;34m[3]\033[0m setup additional packages (asciiart cmatrix $kali neofetch net-tools nmap openfortivpn remmina tty-clock)? press [y]es/[n]o or [q]uit.\n"
		while true; do
                readOne
                case $result in
                        [yY]* )
                                dc3="yes"
								break;;
                        [nN]* )
                                dc3="no"
								break;;
                        [qQ]* )
                                printf "bye\n"
                                exit;;
                        * )
                                ;;
                esac
        done
		
		printf "\033[1;34m[4]\033[0m setup font (anonymice-nf unzip wget)? press [y]es/[n]o or [q]uit.\n"
		while true; do
                readOne
                case $result in
                        [yY]* )
                                dc4="yes"
								break;;
                        [nN]* )
                                dc4="no"
								break;;
                        [qQ]* )
                                printf "bye\n"
                                exit;;
                        * )
                                ;;
                esac
        done
		
		printf "\033[1;34msetup packages for i3 windowmanager: \033[0m $dc2\n"
		printf "\033[1;34msetup additional packages: \033[0m $dc3\n"
		printf "\033[1;34msetup font: \033[0m $dc4\n"		
		printf "\033[1;34mrequesting sudo privileges for setup\n"		
		sudo echo "elevated"
		printf "\033[1;34m[>]\033[0m press [y] to start setup or [q] to quit.\n"
		
        yesOrQuit
		
		sudo apt install curl -y		
		sudo apt install git -y
		sudo apt install python -y  
		sudo apt install zsh -y
		
		zshSetup

		if [ "$dc2" = "yes" ]
		then
			sudo apt install compton -y
			sudo apt install feh -y
			sudo apt install i3-gaps -y
			sudo apt install mugshot -y
			sudo apt install rofi -y
			sudo apt install xfce4-terminal -y
			
			# avatar
			curl -o ~/k.png https://avatars.githubusercontent.com/u/56166006?s=460&u=90d8b9564b0c06ae16ea1b62e2b6b741fdf52842&v=4
			
			# wallpapers
			curl -o ~/.config/i3/config https://raw.githubusercontent.com/stefanableitinger/pointhub/master/i3_config
			
			sudo mkdir -p /usr/share/backgrounds/custom/

			sudo curl -o /usr/share/backgrounds/custom/innere-stadt.png https://raw.githubusercontent.com/stefanableitinger/pointhub/master/innere-stadt.png
			sudo curl -o /usr/share/backgrounds/custom/innere-stadt-lockscreen.png https://raw.githubusercontent.com/stefanableitinger/pointhub/master/innere-stadt-lockscreen.png

			if [ "$kali" = " endlessh firejail jail2ban" ]
			then
				curl -o /usr/share/backgrounds/custom/wallpaper.png https://raw.githubusercontent.com/stefanableitinger/pointhub/master/kali.png
				curl -o /usr/share/backgrounds/custom/wallpaper-lockscreen.png https://raw.githubusercontent.com/stefanableitinger/pointhub/master/kali-lockscreen.png
			else
				curl -o /usr/share/backgrounds/custom/wallpaper.png https://raw.githubusercontent.com/stefanableitinger/pointhub/master/ubuntu.png
				curl -o /usr/share/backgrounds/custom/wallpaper-lockscreen.png https://raw.githubusercontent.com/stefanableitinger/pointhub/master/ubuntu-lockscreen.png
			fi
			
			# config
			curl -o ~/.config/i3/config https://raw.githubusercontent.com/stefanableitinger/pointhub/master/i3_config
		fi
		
		if [ "$dc3" = "yes" ]
		then
			sudo apt install asciiart -y
			sudo apt install cmatrix -y
			sudo apt install neofetch -y
			sudo apt install net-tools -y
			sudo apt install nmap -y
			sudo apt install openfortivpn -y
			sudo apt install remmina -y
			sudo apt install tty-clock -y
		
			if [ "$kali" = " endlessh firejail jail2ban" ]
			then
				sudo apt install endlessh -y			
				sudo apt install firejail -y		
				sudo apt install jail2ban -y
			fi
		fi

		if [ "$dc4" = "yes" ]
		then
			sudo apt install unzip -y
			sudo apt install wget -y

			sudo mkdir -p /usr/share/fonts/truetype/anonymice/
			sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/AnonymousPro.zip -P /usr/share/fonts/truetype/anonymice/
			sudo unzip -u /usr/share/fonts/truetype/anonymice/AnonymousPro.zip -d /usr/share/fonts/truetype/anonymice/
			sudo rm /usr/share/fonts/truetype/anonymice/AnonymousPro.zip
		fi
		}

kaliSetup () {
		kali=" endlessh firejail jail2ban"
		debianSetup
		}

androidSetup () {
		printf "\033[1;34m[1]\033[0m setup contains required packages for oh-my-zsh with p10k (curl git python zsh).\n"
		printf "\033[1;34m[2]\033[0m setup additional packages (cmatrix espeak neofetch net-tools nmap openssh tty-clock)? press [y]es/[n]o or [q]uit.\n"
		
		while true; do
                readOne
                case $result in
                        [yY]* )
                                ac2="yes"
								break;;
                        [nN]* )
                                ac2="no"
								break;;
                        [qQ]* )
                                printf "bye\n"
                                exit;;
                        * )
                                ;;
                esac
        done
		
		printf "\033[1;34m[3]\033[0m download and setup termux configuration? press [y]es/[n]o or [q]uit.\n"
		
		while true; do
                readOne
                case $result in
                        [yY]* )
                                ac3="yes"
								break;;
                        [nN]* )
                                ac3="no"
								break;;
                        [qQ]* )
                                printf "bye\n"
                                exit;;
                        * )
                                ;;
                esac
        done
		
		printf "\033[1;34msetup additional packages: \033[0m $ac2\n"
		printf "\033[1;34msetup termux configuration: \033[0m $ac3\n"
		printf "\033[1;34m[>]\033[0m press [y] to start setup or [q] to quit.\n"
		
        yesOrQuit
		
		pkg install curl
		pkg install git
		pkg install python
		pkg install zsh		
		
		zshSetup

		if [ "$ac2" = "yes" ]
		then
			pkg install cmatrix
			pkg install espeak
			pkg install neofetch
			pkg install net-tools
			pkg install nmap
			pkg install openssh
			pkg install tty-clock
		fi
		
		if [ "$ac3" = "yes" ]
		then
			curl -o ~/.termux/termux.properties https://raw.githubusercontent.com/stefanableitinger/pointhub/master/termux.properties -s
		fi		
		}

welcome

if [ $(uname -o) = "Android" ];
then
	printf "\033[1;34mandroid os detected\033[m\n"
	printf "\033[1;34m[>]\033[m press [y] to configure setup for android/termux or [q] to quit.\n"

	yesOrQuit
	
	androidSetup
	
elif [ $(uname -o) = "GNU/Linux" ];
then
	case "$(uname -r)" in
			*ARCH*)
					printf "\033[1;34march linux os detected\033[m\n"
					printf "not yet implemented.\n"
					printf "bye\n"
					exit;;
			*Microsoft*)
					printf "\033[1;34mwsl detected\033[m\n"
					printf "\033[1;34m[>]\033[m press [y] to configure setup using apt package manager or [q] to quit.\n"
					yesOrQuit
					kali=""
					debianSetup;;
			*Re4son*)
					printf "\033[1;34mkali linux os detected\033[m\n"
					printf "\033[1;34m[>]\033[m press [y] to configure setup for kali linux or [q] to quit.\n"
					yesOrQuit
					kaliSetup;;
			*) ... 
					printf "\033[1;34msome linux os detected\033[m\n"
					printf "\033[1;34m[>]\033[m press [y] to configure setup using apt package manager or [q] to quit.\n"
					yesOrQuit
					kali=""
					debianSetup;;
					
	esac
fi
		
printf "\033[1;34m           _                                           _      _         \033[m\n"
printf "\033[1;34m  ___  ___| |_ _   _ _ __     ___ ___  _ __ ___  _ __ | | ___| |_ ___   \033[m\n"
printf "\033[1;34m / __|/ _ \ __| | | | |_ \   / __/ _ \| |_ | _ \| |_ \| |/ _ \ __/ _ \  \033[m\n"
printf "\033[1;34m \__ \  __/ |_| |_| | |_) | | (_| (_) | | | | | | |_) | |  __/ ||  __/  \033[m\n"
printf "\033[1;34m |___/\___|\__|\__|_| |__/   \___\___/|_| |_| |_| |__/|_|\___|\__\___|  \033[m\n"
printf "\033[1;34m                    |_|                         |_|                     \033[m\n"
printf "\033[1;34m                                                                        \033[m\n"

printf "bye\n"