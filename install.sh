#!/bin/sh
# created by stefan ableitinger on 20/apr/2021
# setup wizard

welcome () {
	printf "\033[1;34m           _                          _                  _  \033[m\n"
	printf "\033[1;34m  ___  ___| |_ _   _ _ __   __      _(_)______ _ _ __ __| | \033[m\n"
	printf "\033[1;34m / __|/ _ \ __| | | | |_ \  \ \ /\ / / |_  / _| | |__/ _| | \033[m\n"
	printf "\033[1;34m \__ \  __/ |_| |_| | |_) |  \ V  V /| |/ / (_| | | | (_| | \033[m\n"
	printf "\033[1;34m |___/\___|\__|\__|_| |__/    \_/\_/ |_/___\__|_|_|  \__|_| \033[m\n"
	printf "\033[1;34mby stefanableitinger|_|                                     \033[m\n"
	printf "\n"
	}

complete() {
	printf "\033[1;34m           _                     _                    _  \033[m\n"
	printf "\033[1;34m  ___  ___| |_ _   _ _ __     __| | ___  _ __   ___  | | \033[m\n"
	printf "\033[1;34m / __|/ _ \ __| | | | |_ \   / _| |/ _ \| |_ \ / _ \ | | \033[m\n"
	printf "\033[1;34m \__ \  __/ |_| |_| | |_) | | (_| | (_) | | | |  __/ |_| \033[m\n"
	printf "\033[1;34m |___/\___|\__|\__,_| |__/   \__,_|\___/|_| |_|\___| (_) \033[m\n"
	printf "\033[1;34mplease type zsh and |_|                                  \033[m\n"
	printf "\033[1;34mhave a nice day!                                         \033[m\n"
	printf "\033[1;34mbye                                                      \033[m\n"
	}

readOne () {
        oldstty=$(stty -g)
        stty -icanon -echo min 1 time 0
        result=$(dd bs=1 count=1 2>/dev/null)
        stty "$oldstty"
        }

testit () {
		if [ ! -e ~/.zshrc ]
		then
			echo "exists"
		else
			echo "does not exist"
		fi
	}

continueOrQuit () {
		printf "\033[1;34m[?]\033[0m press [\033[1;34mc\033[m] to continue or [\033[1;34mq\033[m] to quit.\n"
		while true; do
			readOne
			case $result in
				[cC]* )
					break;;
				[qQ]* )
					printf "bye\n"
					exit;;
				* )
					;;
			esac
		done
		}

includeSkipOrQuit () {
	printf "\033[1;34m[?]\033[0m press [\033[1;34my\033[m] to install [\033[1;34mf\033[m] to overwrite [\033[1;34mn\033[m] to skip or [\033[1;34mq\033[m] to quit\n"

	while true; do
		readOne
		case $result in
			[yY]* )
				choice="install"
				break;;
			[fF]* )
				choice="overwrite"
				break;;
			[nN]* )
				choice="no"
				break;;
			[qQ]* )
				printf "bye\n"
				exit;;
			* )
				;;
		esac
	done
	}

overwriteOrSkip () {
	printf "\033[1;34m[?]\033[0m press [\033[1;34mo\033[m] to overwrite [\033[1;34mn\033[m] to skip or [\033[1;34mq\033[m] to quit\n"

	while true; do
		readOne
		case $result in
			[nN]* )
				choice="no"
				printf "\033[1;31m[!] skipping\033[0m\n"
				break;;
			[oO]* )
				choice="overwrite"
				break;;
			[qQ]* )
				printf "bye\n"
				exit;;
			* )
				;;
		esac
	done
	}

zshSetup () {
		# github repositories
		# https://github.com/ohmyzsh/ohmyzsh
		printf "\033[1;34m[1.2] setup oh-my-zsh\033[0m\n"		

		if [ -d ~/.oh-my-zsh/ ] && [ $dc1 != "overwrite" ];
		then
			printf "\033[1;31m[1.2] oh-my-zsh already exists\033[0m\n"
			overwriteOrSkip
		fi

		if [ ! -d ~/.oh-my-zsh/ ] || [ $dc1 = "overwrite" ] || [ $choice = "overwrite" ];
		then
			printf "\033[1;34m[1.2] download oh-my-zsh\033[0m\n"

			rm ~/.oh-my-zsh -rf
			unset ZSH
			cd ~
			sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh 2>/dev/null)" "" --unattended

			printf "\033[1;34m[1.2] download oh-my-zsh: complete\033[0m\n"
		fi
		choice=""

		# https://github.com/romkatv/powerlevel10k
		printf "\033[1;34m[1.3] setup plugin (1/3) powerlevel10k\033[0m\n"		

		if [ -d ~/.oh-my-zsh/custom/themes/powerlevel10k/ ] && [ $dc1 != "overwrite" ];
		then
			printf "\033[1;31m[1.3] plugin (1/3) powerlevel10k already exists\033[0m\n"
			overwriteOrSkip
		fi

		if [ ! -d ~/.oh-my-zsh/custom/themes/powerlevel10k/ ] || [ $dc1 = "overwrite" ] || [ $choice = "overwrite" ];
		then
			printf "\033[1;34m[1.3] download plugin (1/3) powerlevel10k\033[0m\n"

			git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

			printf "\033[1;34m[1.3] download plugin (1/3) powerlevel10k: complete\033[0m\n"
		fi
		choice=""

		# https://github.com/zsh-users/zsh-autosuggestions
		printf "\033[1;34m[1.4] setup plugin (2/3) zsh-autosuggestions\033[0m\n"		

		if [ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/ ] && [ $dc1 != "overwrite" ];
		then
			printf "\033[1;31m[1.4] plugin (2/3) zsh-autosuggestions already exists\033[0m\n"
			overwriteOrSkip
		fi

		if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/ ] || [ $dc1 = "overwrite" ] || [ $choice = "overwrite" ];
		then
			printf "\033[1;34m[1.4] download plugin (2/3) zsh-autosuggestions\033[0m\n"

			git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

			printf "\033[1;34m[1.4] download plugin (2/3) zsh-autosuggestions: complete\033[0m\n"
		fi
		choice=""

		# https://github.com/zsh-users/zsh-syntax-highlighting
		printf "\033[1;34m[1.5] setup plugin (3/3) zsh-syntax-highlighting\033[0m\n"		

		if [ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/ ] && [ $dc1 != "overwrite" ];
		then
			printf "\033[1;31m[1.5] plugin (3/3) zsh-syntax-highlighting already exists\033[0m\n"
			overwriteOrSkip
		fi

		if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/ ] || [ $dc1 = "overwrite" ] || [ $choice = "overwrite" ];
		then
			printf "\033[1;34m[1.5] download plugin (3/3) zsh-syntax-highlighting\033[0m\n"

			git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

			printf "\033[1;34m[1.5] download plugin (3/3) zsh-syntax-highlighting: complete\033[0m\n"
		fi
		choice=""

		# config files
		printf "\033[1;34m[1.6] setup config files\033[0m\n"		

		if [ -e ~/.zshrc ] && [ $dc1 != "overwrite" ];
		then
			printf "\033[1;31m[1.6] config file (1/2) .zshrc already exists\033[0m\n"
			overwriteOrSkip
		fi

		if [ ! -e ~/.zshrc ] || [ $dc1 = "overwrite" ] || [ $choice = "overwrite" ];
		then
			printf "\033[1;34m[1.6] download config file (1/2) .zshrc\033[0m\n"

			curl --silent --output ~/.zshrc https://raw.githubusercontent.com/stefanableitinger/pointhub/master/.zshrc		

			printf "\033[1;34m[1.6] download config file (1/2) .zshrc: complete\033[0m\n"
		fi
		choice=""

		if [ -e ~/.p10k.zsh ] && [ $dc1 != "overwrite" ];
		then
			printf "\033[1;31m[1.6] config file (2/2) .p10k.zsh already exists\033[0m\n"
			overwriteOrSkip
		fi

		if [ ! -e ~/.p10k.zsh ] || [ $dc1 = "overwrite" ] || [ $choice = "overwrite" ];
		then
			printf "\033[1;34m[1.6] download config file (2/2) .p10k.zsh\033[0m\n"

			curl --silent --output ~/.p10k.zsh https://raw.githubusercontent.com/stefanableitinger/pointhub/master/.p10k.zsh

			printf "\033[1;34m[1.6] download config file (2/2) .p10k.zsh: complete\033[0m\n"
		fi
		choice=""
		}

debianSetup () {
		printf "\033[1;34m[1] setup oh-my-zsh with p10k (curl git python zsh dotfiles)?\033[0m\n"
		includeSkipOrQuit
		dc1=$choice

		printf "\033[1;34m[2] setup packages for i3 windowmanager (feh i3-gaps mugshot picom rofi xfce4-terminal dotfiles)?\033[0m\n"
		includeSkipOrQuit
		dc2=$choice

		printf "\033[1;34m[3] setup additional packages (asciiart cmatrix endlessh.service firejail fail2ban neofetch net-tools nmap openfortivpn remmina samba.service tty-clock dotfiles)?\033[0m\n"
		includeSkipOrQuit
		dc3=$choice

		printf "\033[1;34m[4] download font (spacemono-nf)?\033[0m\n"
		includeSkipOrQuit
		dc4=$choice

		# check privileges
		if [ $(id -u) -ne 0 ];
		then
			if [ $dc1 != "no" ] || [ $dc2 != "no" ] || [ $dc3 != "no" ];
			then
				printf "\033[1;34m[!] using root privileges for setup\033[0m\n"
				sudo printf "" 2>/dev/null

				if [ "$?" = "1" ];
				then
					printf "\033[1;31m[!] root privileges were not granted\033[0m\n"			
					printf "bye\n"
					exit
				fi
			fi
		fi

		printf "\033[1;34m[1] setup oh-my-zsh with p10k: \033[0m $dc1\n"
		printf "\033[1;34m[2] setup i3-gaps with rofi: \033[0m $dc2\n"
		printf "\033[1;34m[3] setup additional packages: \033[0m $dc3\n"
		printf "\033[1;34m[4] download font: \033[0m $dc4\n"

		continueOrQuit
		printf "\033[1;34m[!] setup starting \033[0m $ac3\n"

		if [ $dc1 != "no" ];
		then
			printf "\033[1;34m[1] start\033[0m\n"

			# packages
			printf "\033[1;34m[1.1] installing packages\033[0m\n"
			sudo apt install curl git python zsh -y
			printf "\033[1;34m[1.1] installing packages: complete\033[0m\n"

			# zshSetup
			zshSetup

			printf "\033[1;34m[1] complete\033[0m\n"
		fi

		if [ $dc2 != "no" ];
		then
			printf "\033[1;34m[2] start\033[0m\n"

			# packages
			printf "\033[1;34m[2.1] installing packages\033[0m\n"
			sudo apt install feh i3-gaps mugshot picom rofi xfce4-terminal -y
			printf "\033[1;34m[2.1] installing packages: complete\033[0m\n"

			# config files
			printf "\033[1;34m[2.2] download config files\033[0m\n"		
			mkdir --parents ~/.config/i3

			if [ -e ~/.config/i3/config ] && [ $dc2 != "overwrite" ];
			then
				printf "\033[1;31m[2.2] config file (1/2) i3/config already exists\033[0m\n"
				overwriteOrSkip
			fi
			if [ ! -e ~/.config/i3/config ] || [ $dc2 = "overwrite" ] || [ $choice = "overwrite" ];
			then
				printf "\033[1;34m[2.2] download config file (1/2) i3/config\033[0m\n"

				curl --silent --output ~/.config/i3/config https://raw.githubusercontent.com/stefanableitinger/pointhub/master/i3_config
				sed -i "s,HOMEDIR,$HOME," ~/.config/i3/config		

				printf "\033[1;34m[2.2] download config file (1/2) i3/config: complete\033[0m\n"
			fi
			choice=""

			if [ -e ~/.config/i3/i3_status.sh ] && [ $dc2 != "overwrite" ];
			then
				printf "\033[1;31m[2.2] config file (2/2) i3_status.sh already exists\033[0m\n"
				overwriteOrSkip
			fi
			if [ ! -e ~/.config/i3/i3_status.sh ] || [ $dc2 = "overwrite" ] || [ $choice = "overwrite" ];
			then
				printf "\033[1;34m[2.2] download config file (2/2) i3/config\033[0m\n"

				curl --silent --output ~/.config/i3/i3_status.sh https://raw.githubusercontent.com/stefanableitinger/pointhub/master/i3_status.sh		

				printf "\033[1;34m[2.2] download config file (2/2) i3_status.sh: complete\033[0m\n"
			fi
			choice=""

			printf "\033[1;34m[2.2] download config files: complete\033[0m\n"

			# image ressources
			printf "\033[1;34m[2.3] download image ressources\033[0m\n"		
			mkdir --parents ~/Pictures
			mkdir --parents ~/.local/share/backgrounds

			# user icon
			if [ -e ~/Pictures/k.png ] && [ $dc2 != "overwrite" ];
			then
				printf "\033[1;31m[2.3] image ressource (1/4) user icon already exists\033[0m\n"
				overwriteOrSkip
			fi
			if [ ! -e ~/Pictures/k.png ] || [ $dc2 = "overwrite" ] || [ $choice = "overwrite" ];
			then
				printf "\033[1;34m[2.3] download image ressource (1/4) user icon\033[0m\n"
				curl --silent --output ~/Pictures/k.png https://avatars.githubusercontent.com/u/56166006
				printf "\033[1;34m[2.3] image ressource (1/4) user icon: complete\033[0m\n"
			fi
			choice=""

			# wallpaper
			if [ -e ~/.local/share/backgrounds/innere-stadt.png ] && [ $dc2 != "overwrite" ];
			then
				printf "\033[1;31m[2.3] image ressource (2/4) wallpaper/innere-stadt already exists\033[0m\n"
				overwriteOrSkip
			fi
			if [ ! ~/.local/share/backgrounds/innere-stadt.png ] || [ $dc2 = "overwrite" ] || [ $choice = "overwrite" ];
			then
				printf "\033[1;34m[2.3] download image ressource (2/4) wallpaper/innere-stadt\033[0m\n"
				curl --silent --output-dir ~/.local/share/backgrounds https://raw.githubusercontent.com/stefanableitinger/pointhub/master/innere-stadt.png
				curl --silent --output-dir ~/.local/share/backgrounds https://raw.githubusercontent.com/stefanableitinger/pointhub/master/innere-stadt-lockscreen.png
				printf "\033[1;34m[2.3] image ressource (2/4) wallpaper/innere-stadt: complete\033[0m\n"
			fi
			choice=""

			if [ -e ~/.local/share/backgrounds/fedora.png ] && [ $dc2 != "overwrite" ];
			then
				printf "\033[1;31m[2.3] image ressource (3/4) wallpaper/fedora already exists\033[0m\n"
				overwriteOrSkip
			fi
			if [ ! ~/.local/share/backgrounds/fedora.png ] || [ $dc2 = "overwrite" ] || [ $choice = "overwrite" ];
			then
				printf "\033[1;34m[2.3] download image ressource (3/4) wallpaper/fedora\033[0m\n"
				curl --silent --output ~/.local/share/backgrounds https://raw.githubusercontent.com/stefanableitinger/pointhub/master/fedora.png
				curl --silent --output ~/.local/share/backgrounds https://raw.githubusercontent.com/stefanableitinger/pointhub/master/fedora-lockscreen.png	
				printf "\033[1;34m[2.3] image ressource (3/4) wallpaper/fedora: complete\033[0m\n"
			fi
			choice=""

			if [ -e ~/.local/share/backgrounds/ubuntu.png ] && [ $dc2 != "overwrite" ];
			then
				printf "\033[1;31m[2.3] image ressource (4/4) wallpaper/ubuntu already exists\033[0m\n"
				overwriteOrSkip
			fi
			if [ ! ~/.local/share/backgrounds/ubuntu.png ] || [ $dc2 = "overwrite" ] || [ $choice = "overwrite" ];
			then
				printf "\033[1;34m[2.3] download image ressource (4/4) wallpaper/ubuntu\033[0m\n"
				curl --silent --output ~/.local/share/backgrounds https://raw.githubusercontent.com/stefanableitinger/pointhub/master/ubuntu.png
				curl --silent --output ~/.local/share/backgrounds https://raw.githubusercontent.com/stefanableitinger/pointhub/master/ubuntu-lockscreen.png
				printf "\033[1;34m[2.3] image ressource (4/4) wallpaper/ubuntu: complete\033[0m\n"
			fi
			choice=""

			printf "\033[1;34m[2.3] download image ressources: complete\033[0m\n"	

			printf "\033[1;34m[2] complete\033[0m\n"
		fi

		if [ $dc3 != "no" ];
		then
			printf "\033[1;34m[3] start\033[0m\n"

			# packages
			printf "\033[1;34m[3.1] installing packages\033[0m\n"			
			sudo apt install asciiart cmatrix endlessh firejail fail2ban neofetch net-tools nmap openfortivpn remmina samba tty-clock -y
			printf "\033[1;34m[3.1] installing packages: complete\033[0m\n"			

			# config files
			printf "\033[1;34m[3.2] download config files\033[0m\n"		
			sudo mkdir --parents /etc/samba
			sudo mkdir --parents /etc/endlessh

			if [ -e /etc/samba/smb.conf ] && [ $dc3 != "overwrite" ];
			then
				printf "\033[1;31m[3.2] config file (1/2) smb.conf already exists\033[0m\n"
				overwriteOrSkip
			fi
			if [ ! -e /etc/samba/smb.conf ] || [ $dc3 = "overwrite" ] || [ $choice = "overwrite" ];
			then
				printf "\033[1;34m[3.2] download config file (1/2) smb.conf\033[0m\n"
				sudo curl --silent -O --output-dir /etc/samba/ https://raw.githubusercontent.com/stefanableitinger/pointhub/master/smb.conf
				printf "\033[1;34m[3.2] download config file (1/2) smb.conf: complete\033[0m\n"
			fi
			choice=""

			if [ -e /etc/endlessh/config ] && [ $dc3 != "overwrite" ];
			then
				printf "\033[1;31m[3.2] config file (2/2) endlessh/config already exists\033[0m\n"
				overwriteOrSkip
			fi
			if [ ! -e /etc/endlessh/config ] || [ $dc3 = "overwrite" ] || [ $choice = "overwrite" ];
			then
				printf "\033[1;34m[3.2] download config file (2/2) endlessh/config\033[0m\n"
				sudo curl --silent --output /etc/endlessh/config https://raw.githubusercontent.com/stefanableitinger/pointhub/master/endlessh_config
				printf "\033[1;34m[3.2] download config file (2/2) endlessh/config: complete\033[0m\n"
			fi
			choice=""

			printf "\033[1;34m[3.2] download config files: complete\033[0m\n"

			printf "\033[1;34m[3] complete\033[0m\n"
		fi

		if [ $dc4 != "no" ] || [ $dc4 = "overwrite" ];
		then
			printf "\033[1;34m[4] start\033[0m\n"

			# font
			mkdir --parents ~/.local/share/fonts/spacemono-nf

			if [ -e ~/.local/share/fonts/spacemono-nf/Space\ Mono\ Nerd\ Font\ Complete\ Mono.ttf ] && [ $dc4 != "overwrite" ];
			then
				printf "\033[1;31m[4.1] font spacemono-nf already exists\033[0m\n"
				overwriteOrSkip
			fi
			if [ ! -e ~/.local/share/fonts/spacemono-nf/Space\ Mono\ Nerd\ Font\ Complete\ Mono.ttf ] || [ $dc4 = "overwrite" ] || [ $choice = "overwrite" ];
			then
				printf "\033[1;34m[4.1] download font spacemono-nf\033[0m\n"
				curl --silent --output ~/.local/share/fonts/spacemono-nf/Space\ Mono\ Nerd\ Font\ Complete\ Mono.ttf https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/SpaceMono/Regular/complete/Space%20Mono%20Nerd%20Font%20Complete%20Mono.ttf

				fc-cache -rf ~/.local/share/fonts/spacemono-nf
				printf "\033[1;34m[4.1] download font spacemono-nf: complete\033[0m\n"
			fi
			choice=""

			printf "\033[1;34m[4] complete\033[0m\n"
		fi
		}

checkStartService () {
	if [ $(systemctl is-enabled $1.service) = "disabled" ];
	then
		printf "\033[1;34m[3.x] enabling $1.service \033[0m\n"
		sudo systemctl enable $1.service
	fi

	if [ $(systemctl is-active $1.service) = "inactive" ];
	then
		printf "\033[1;34m[3.x] starting $1.service \033[0m\n"
		sudo systemctl start $1.service
	fi
	}

startServices () {
		if [ $dc3 != "no" ];
		then
			checkStartService smbd
			checkStartService endlessh
			checkStartService fail2ban
		fi
	}

androidSetup () {
		printf "\033[1;34m[1] setup oh-my-zsh with p10k (curl git python zsh dotfiles)?\033[0m\n"
		includeSkipOrQuit
		dc1=$choice

		printf "\033[1;34m[2] setup additional packages (cmatrix espeak neofetch net-tools nmap openssh tty-clock)?\033[0m\n"
		includeSkipOrQuit
		dc2=$choice

		printf "\033[1;34m[3] download termux configuration?\033[0m\n"
		includeSkipOrQuit
		dc3=$choice

		printf "\033[1;34m[4] download font (meslolgs-nf)?\033[0m\n"
		includeSkipOrQuit
		dc4=$choice

		printf "\033[1;34m[1] setup oh-my-zsh with p10k: \033[0m $dc1\n"
		printf "\033[1;34m[2] setup additional packages: \033[0m $dc2\n"
		printf "\033[1;34m[3] download termux configuration: \033[0m $dc3\n"
		printf "\033[1;34m[4] download font: \033[0m $dc4\n"

		continueOrQuit
		
		printf "\033[1;34m[!] setup starting \033[0m $ac3\n"

		if [ $dc1 != "no" ];
		then
			printf "\033[1;34m[1] start\033[0m\n"
			
			# packages
			printf "\033[1;34m[1.1] installing packages\033[0m\n"
			pkg install curl git python zsh -y
			printf "\033[1;34m[1.1] installing packages: complete\033[0m\n"
			
			zshSetup
			
			printf "\033[1;34m[1] complete\033[0m\n"
		fi

		if [ $dc2 != "no" ];
		then
			printf "\033[1;34m[2] start\033[0m\n"

			# packages
			printf "\033[1;34m[2.1] installing packages\033[0m\n"			
			pkg install cmatrix espeak neofetch net-tools nmap openssh tty-clock -y
			printf "\033[1;34m[2.1] installing packages: complete\033[0m\n"

			sshd
			
			printf "\033[1;34m[2] complete\033[0m\n"
		fi

		if [ $dc3 != "no" ];
		then
			printf "\033[1;34m[3] start\033[0m\n"
				
			if [ ! -e ~/.termux/termux.properties/termux.properties ] || [ $dc3 = "overwrite" ];
			then
				printf "\033[1;34m[3.1] download config file\033[0m\n"
				curl --silent --output ~/.termux/termux.properties https://raw.githubusercontent.com/stefanableitinger/pointhub/master/termux.properties
				
				termux-reload-settings
				printf "\033[1;34m[3.1] download config file: complete\033[0m\n"
			fi			
				
			printf "\033[1;34m[3] complete\033[0m\n"
		fi

		if [ $dc4 != "no" ];
		then
			printf "\033[1;34m[4] start\033[0m\n"
			
			if [ ! -e ~/.termux/font.ttf ] || [ $dc4 = "overwrite" ];
			then				
				printf "\033[1;34m[4.1] download font\033[0m\n"
				curl --silent --output ~/.termux/font.ttf https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/AnonymousPro/complete/Anonymice%20Nerd%20Font%20Complete%20Mono.ttf

				termux-reload-settings
				printf "\033[1;34m[4.1] download font: complete\033[0m\n"
			fi
			
			printf "\033[1;34m[4] complete\033[0m\n"
		fi
		}

main () {
	welcome

	if [ $(uname -o) = "Android" ];
	then
		printf "\033[1;34m android os detected\033[m\n"
		continueOrQuit
		androidSetup
		if [ $dc1 = "yes" ];
		then
			chsh -s zsh
		fi

		complete

	elif [ $(uname -o) = "GNU/Linux" ];
	then
		case "$(uname -r)" in
			*ARCH*)
				printf "\033[1;34m[!]\033[m arch linux os detected\n"
				printf "\033[1;31m[!] not yet implemented\033[m\n"
				printf "bye\n"
				exit;;
			*Microsoft*)
				printf "\033[1;34m[!] wsl detected\033[m\n"
				continueOrQuit
				debianSetup;;
			*Re4son*)
				printf "\033[1;34m[!]\033[m kali linux os detected\n"
				continueOrQuit
				debianSetup
				startServices;;
			*) ...
				printf "\033[1;34m[!]\033[m some linux os detected\n"
				continueOrQuit
				debianSetup
				startServices;;
		esac

                if [ $dc1 = "yes" ] || [ ! "$SHELL" = "$(which zsh)" ];
                then
			printf "\033[1;34m[-] changing default shell to zsh for user \033[0m$(whoami)\n"
                        chsh -s $(which zsh) $(whoami)
			printf "\033[1;34m[-] changing default shell to zsh: complete\033[0m\n"
                fi

		complete
	fi
	}

main
#testit
