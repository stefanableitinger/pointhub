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

test () {	
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
	printf "\033[1;34m[-]\033[0m press [\033[1;34my\033[m] to install [\033[1;34mf\033[m] to overwrite [\033[1;34mn\033[m] to skip or [\033[1;34mq\033[m] to quit\n"

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
				printf "\033[1;31m[ ] skipping\033[0m\n"
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
		printf "\033[1;34m[ ] setup oh-my-zsh\033[0m\n"		
		
		if [ -d ~/.oh-my-zsh/ ] && [ $dc1 != "overwrite" ];
		then
			printf "\033[1;31m[!] oh-my-zsh already exists\033[0m\n"
			overwriteOrSkip
		fi
			
		if [ ! -d ~/.oh-my-zsh/ ] || [ $dc1 = "overwrite" ] || [ $choice = "overwrite" ];
		then
			printf "\033[1;34m[ ] downloading oh-my-zsh\033[0m\n"
			
			cd ~
			sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh 2>/dev/null)" "" --unattended

			printf "\033[1;34m[ ] downloading oh-my-zsh: complete\033[0m\n"
		fi

		choice=""
		
		printf "\033[1;34m[ ] setup plugin (1/4) powerlevel10k\033[0m\n"		

		if [ -d ~/.oh-my-zsh/custom/themes/powerlevel10k/ ] && [ $dc1 != "overwrite" ];
		then
			printf "\033[1;31m[!] plugin (1/4) powerlevel10k already exists\033[0m\n"
			overwriteOrSkip
		fi
			
		if [ ! -d ~/.oh-my-zsh/custom/themes/powerlevel10k/ ] || [ $dc1 = "overwrite" ] || [ $choice = "overwrite" ];
		then
			printf "\033[1;34m[ ] downloading plugin (1/4) powerlevel10k\033[0m\n"
			
			git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
			
			printf "\033[1;34m[ ] downloading plugin (1/4) powerlevel10k: complete\033[0m\n"
		fi
		
		choice=""

		printf "\033[1;34m[ ] setup plugin (2/4) zsh-autosuggestions\033[0m\n"		

		if [ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/ ] && [ $dc1 != "overwrite" ];
		then
			printf "\033[1;31m[!] plugin (2/4) zsh-autosuggestions already exists\033[0m\n"
			overwriteOrSkip
		fi
			
		if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/ ] || [ $dc1 = "overwrite" ] || [ $choice = "overwrite" ];
		then
			printf "\033[1;34m[ ] downloading plugin (2/4) zsh-autosuggestions\033[0m\n"
			
			git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
			
			printf "\033[1;34m[ ] downloading plugin (2/4) zsh-autosuggestions: complete\033[0m\n"
		fi

		choice=""

		printf "\033[1;34m[ ] setup plugin (3/4) zsh-syntax-highlighting\033[0m\n"		

		if [ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/ ] && [ $dc1 != "overwrite" ];
		then
			printf "\033[1;31m[!] plugin (3/4) zsh-syntax-highlighting already exists\033[0m\n"
			overwriteOrSkip
		fi
			
		if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/ ] || [ $dc1 = "overwrite" ] || [ $choice = "overwrite" ];
		then
			printf "\033[1;34m[ ] downloading plugin (3/4) zsh-syntax-highlighting\033[0m\n"
			
			git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
			
			printf "\033[1;34m[ ] downloading plugin (3/4) zsh-syntax-highlighting: complete\033[0m\n"
		fi

		choice=""

		printf "\033[1;34m[ ] setup plugin (4/4) autojump\033[0m\n"		

		if [ -d ~/.oh-my-zsh/custom/plugins/autojump/ ] && [ $dc1 != "overwrite" ];
		then
			printf "\033[1;31m[!] plugin (4/4) autojump already exists\033[0m\n"
			overwriteOrSkip
		fi
			
		if [ ! -d ~/.oh-my-zsh/custom/plugins/autojump/ ] || [ $dc1 = "overwrite" ] || [ $choice = "overwrite" ];
		then
			printf "\033[1;34m[ ] downloading plugin (4/4) autojump\033[0m\n"
			
			git clone git://github.com/wting/autojump.git ~/.oh-my-zsh/custom/plugins/autojump
			cd ~/.oh-my-zsh/custom/plugins/autojump/
			python install.py
			
			printf "\033[1;34m[ ] downloading plugin (4/4) autojump: complete\033[0m\n"
		fi

		choice=""

		printf "\033[1;34m[ ] setup config files\033[0m\n"		
		
		# config files
		if [ -e ~/.zshrc ] && [ $dc1 != "overwrite" ];
		then
			printf "\033[1;31m[!] config file (1/2) .zshrc already exists\033[0m\n"
			overwriteOrSkip
		fi
			
		if [ ! -e ~/.zshrc ] || [ $dc1 = "overwrite" ] || [ $choice = "overwrite" ];
		then
			printf "\033[1;34m[ ] downloading config file (1/2) .zshrc\033[0m\n"
			
			curl --silent --output ~/.zshrc https://raw.githubusercontent.com/stefanableitinger/pointhub/master/.zshrc		

			printf "\033[1;34m[ ] downloading config file (1/2) .zshrc: complete\033[0m\n"
		fi

		choice=""

		if [ -e ~/.p10k.zsh ] && [ $dc1 != "overwrite" ];
		then
			printf "\033[1;31m[!] config file (2/2) .p10k.zsh already exists\033[0m\n"
			overwriteOrSkip
		fi
			
		if [ ! -e ~/.p10k.zsh ] || [ $dc1 = "overwrite" ] || [ $choice = "overwrite" ];
		then
			printf "\033[1;34m[ ] downloading config file (2/2) .p10k.zsh\033[0m\n"
			
			curl --silent --output ~/.p10k.zsh https://raw.githubusercontent.com/stefanableitinger/pointhub/master/.p10k.zsh
			
			printf "\033[1;34m[ ] downloading config file (2/2) .p10k.zsh: complete\033[0m\n"
		fi

		choice=""
		}

debianSetup () {
		printf "\033[1;34m[?] setup oh-my-zsh with p10k (curl git python zsh dotfiles)?\033[0m\n"
		includeSkipOrQuit
		dc1=$choice

		printf "\033[1;34m[?] setup packages for i3 windowmanager (feh i3-gaps mugshot picom rofi xfce4-terminal dotfiles)?\033[0m\n"
		includeSkipOrQuit
		dc2=$choice

		printf "\033[1;34m[?] setup additional packages (asciiart cmatrix endlessh.service firejail fail2ban neofetch net-tools nmap openfortivpn remmina samba.service tty-clock dotfiles)?\033[0m\n"
		includeSkipOrQuit
		dc3=$choice

		printf "\033[1;34m[?] get font (spacemono-nf)?\033[0m\n"
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

		printf "\033[1;34m[!] setup oh-my-zsh with p10k: \033[0m $dc1\n"
		printf "\033[1;34m[!] setup i3-gaps with rofi: \033[0m $dc2\n"
		printf "\033[1;34m[!] setup additional packages: \033[0m $dc3\n"
		printf "\033[1;34m[!] get font: \033[0m $dc4\n"

		continueOrQuit
		printf "\033[1;34m[!] setup starting \033[0m $ac3\n"

		if [ $dc1 != "no" ];
		then
			printf "\033[1;34m[-] setup oh-my-zsh with p10k\033[0m\n"
			
			# packages
			printf "\033[1;34m[ ] installing packages\033[0m\n"
			sudo apt install curl git python zsh -y
			printf "\033[1;34m[ ] installing packages: complete\033[0m\n"
			
			# zshSetup
			if [ $dc1 = "overwrite" ];
			then
				rm ~/.oh-my-zsh -rf
				unset ZSH
			fi
			
			zshSetup
			
			printf "\033[1;34m[-] setup oh-my-zsh with p10k: complete\033[0m\n"
		fi

		if [ $dc2 != "no" ];
		then
			printf "\033[1;34m[-] setup i3-gaps with rofi\033[0m\n"
			
			# packages
			printf "\033[1;34m[ ] installing packages\033[0m\n"
			sudo apt install feh i3-gaps mugshot picom rofi xfce4-terminal -y
			printf "\033[1;34m[ ] installing packages: complete\033[0m\n"
			
			# config files
			if [ ! -d ~/.config/i3/ ] || [ ! -e ~/.config/i3/config ] || [ ! -e ~/.config/i3/i3_status.sh ] || [ $dc2 = "overwrite" ];
			then
				printf "\033[1;34m[ ] downloading config files\033[0m\n"
				
				mkdir --parents ~/.config/i3
								
				if [ ! -e ~/.config/i3/config ] || [ $dc2 = "overwrite" ];
				then
					curl --silent --output ~/.config/i3/config https://raw.githubusercontent.com/stefanableitinger/pointhub/master/i3_config
					sed -i "s,HOMEDIR,$HOME," ~/.config/i3/config
				fi

				if [ ! -e ~/.config/i3/i3_status.sh ] || [ $dc2 = "overwrite" ];
				then
					curl --silent --output ~/.config/i3/i3_status.sh https://raw.githubusercontent.com/stefanableitinger/pointhub/master/i3_status.sh
				fi
				
				printf "\033[1;34m[ ] downloading config files: complete\033[0m\n"
			fi
			
			# wallpapers
			if [ ! -d ~/.local/share/backgrounds/ ] || [ ! -d ~/Pictures/ ] || [ ! -e ~/Pictures/k.png ] || [ ! -e ~/.local/share/backgrounds/innere-stadt.png ] || [ ! -e ~/.local/share/backgrounds/innere-stadt-lockscreen.png ] || [ ! -e ~/.local/share/backgrounds/fedora.png ] || [ ! -e ~/.local/share/backgrounds/fedora-lockscreen.png ] || [ ! -e ~/.local/share/backgrounds/ubuntu.png ] || [ ! -e ~/.local/share/backgrounds/ubuntu-lockscreen.png ] || [ $dc2 = "overwrite" ];
			then
				printf "\033[1;34m[ ] downloading wallpapers\033[0m\n"

				mkdir --parents ~/Pictures
				
				if [ ! -e ~/Pictures/k.png ] || [ $dc2 = "overwrite" ];
				then
					curl --silent --output ~/Pictures/k.png https://avatars.githubusercontent.com/u/56166006
				fi

				mkdir --parents ~/.local/share/backgrounds
				
				if [ ! -e ~/.local/share/backgrounds/innere-stadt.png ] || [ $dc2 = "overwrite" ];
				then
					curl --silent --output-dir ~/.local/share/backgrounds https://raw.githubusercontent.com/stefanableitinger/pointhub/master/innere-stadt.png					
				fi

				if [ ! -e ~/.local/share/backgrounds/innere-stadt-lockscreen.png ] || [ $dc2 = "overwrite" ];
				then
					curl --silent --output-dir ~/.local/share/backgrounds https://raw.githubusercontent.com/stefanableitinger/pointhub/master/innere-stadt-lockscreen.png					
				fi

				if [ ! -e ~/.local/share/backgrounds/fedora.png ] || [ $dc2 = "overwrite" ];
				then
					curl --silent --output ~/.local/share/backgrounds https://raw.githubusercontent.com/stefanableitinger/pointhub/master/fedora.png	
				fi

				if [ ! -e ~/.local/share/backgrounds/fedora-lockscreen.png ] || [ $dc2 = "overwrite" ];
				then
					curl --silent --output ~/.local/share/backgrounds https://raw.githubusercontent.com/stefanableitinger/pointhub/master/fedora-lockscreen.png					
				fi

				if [ ! -e ~/.local/share/backgrounds/ubuntu.png ] || [ $dc2 = "overwrite" ];
				then
					curl --silent --output ~/.local/share/backgrounds https://raw.githubusercontent.com/stefanableitinger/pointhub/master/ubuntu.png					
				fi

				if [ ! -e ~/.local/share/backgrounds/ubuntu-lockscreen.png ] || [ $dc2 = "overwrite" ];
				then
					curl --silent --output ~/.local/share/backgrounds https://raw.githubusercontent.com/stefanableitinger/pointhub/master/ubuntu-lockscreen.png
				fi

				printf "\033[1;34m[ ] downloading wallpapers: complete\033[0m\n"
			fi
			
			printf "\033[1;34m[-] setup i3-gaps with rofi: complete\033[0m\n"
		fi

		if [ $dc3 != "no" ];
		then
			printf "\033[1;34m[-] setup additional packages\033[0m\n"
			
			# packages
			printf "\033[1;34m[ ] installing packages\033[0m\n"			
			sudo apt install asciiart cmatrix endlessh firejail fail2ban neofetch net-tools nmap openfortivpn remmina samba tty-clock -y
			printf "\033[1;34m[ ] installing packages: complete\033[0m\n"			
			
			# config files
			if [ ! -d /etc/samba/ ] || [ ! -e /etc/samba/smb.conf ] || [ $dc3 = "overwrite" ];
			then
				printf "\033[1;34m[ ] downloading config files\033[0m\n"
				
				sudo mkdir --parents /etc/samba
				
				if [ ! -e /etc/samba/smb.conf ] || [ $dc3 = "overwrite" ];
				then
					sudo curl --silent -O --output-dir /etc/samba/ https://raw.githubusercontent.com/stefanableitinger/pointhub/master/smb.conf
				fi				

				sudo mkdir --parents /etc/endlessh
				
				if [ ! -e /etc/endlessh/config ] || [ $dc3 = "overwrite" ];
				then
					sudo curl --silent --output /etc/endlessh/config https://raw.githubusercontent.com/stefanableitinger/pointhub/master/endlessh_config
				fi				
				
				printf "\033[1;34m[ ] downloading config files: complete\033[0m\n"
			fi

			printf "\033[1;34m[-] setup additional packages: complete\033[0m\n"
		fi

		if [ $dc4 != "no" ] || [ $dc4 = "overwrite" ];
		then
			# font
			if [ ! -d ~/.local/share/fonts/spacemono-nf/ ] || [ ! -e ~/.local/share/fonts/spacemono-nf/Space\ Mono\ Nerd\ Font\ Complete\ Mono.ttf ] || [ $dc4 = "overwrite" ];
			then
				printf "\033[1;34m[-] get font\033[0m\n"
			
				mkdir --parents ~/.local/share/fonts/spacemono-nf
				
				if [ ! -e ~/.local/share/fonts/spacemono-nf/Space\ Mono\ Nerd\ Font\ Complete\ Mono.ttf ] || [ $dc4 = "overwrite" ];
				then
					curl --silent --output ~/.local/share/fonts/spacemono-nf/Space\ Mono\ Nerd\ Font\ Complete\ Mono.ttf https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/SpaceMono/Regular/complete/Space%20Mono%20Nerd%20Font%20Complete%20Mono.ttf
				fi
				
				fc-cache -rf ~/.local/share/fonts/spacemono-nf
				
				printf "\033[1;34m[-] get font: complete\033[0m\n"
			fi
		fi
		}

checkStartService () {
	if [ $(systemctl is-enabled $1.service) = "disabled" ];
	then
		printf "\033[1;34m[ ] enabling $1.service \033[0m\n"
		sudo systemctl enable $1.service
	fi

	if [ $(systemctl is-active $1.service) = "inactive" ];
	then
		printf "\033[1;34m[ ] starting $1.service \033[0m\n"
		sudo systemctl start $1.service
	fi
	}

startServices () {
		if [ $dc3 != "no" ];
		then
			printf "\033[1;34m[ ] setup additional packages services\033[0m\n"
			checkStartService smbd
			checkStartService endlessh
			checkStartService fail2ban
			printf "\033[1;34m[ ] setup additional packages services: complete\033[0m\n"
		fi
	}

androidSetup () {
		printf "\033[1;34m[?] setup oh-my-zsh with p10k (curl git python zsh dotfiles)?\033[0m\n"
		includeSkipOrQuit
		dc1=$choice

		printf "\033[1;34m[?] setup additional packages (cmatrix espeak neofetch net-tools nmap openssh tty-clock)?\033[0m\n"
		includeSkipOrQuit
		dc2=$choice

		printf "\033[1;34m[?] setup termux configuration and font (meslolgs-nf)?\033[0m\n"
		includeSkipOrQuit
		dc3=$choice

		printf "\033[1;34m[!] setup oh-my-zsh with p10k: \033[0m $dc1\n"
		printf "\033[1;34m[!] setup additional packages: \033[0m $dc2\n"
		printf "\033[1;34m[!] setup termux configuration and font: \033[0m $dc3\n"

		continueOrQuit
		
		printf "\033[1;34m[!] setup starting \033[0m $ac3\n"

		if [ $dc1 != "no" ];
		then
			printf "\033[1;34m[-] setup oh-my-zsh with p10k\033[0m\n"
			
			# packages
			printf "\033[1;34m[ ] installing packages\033[0m\n"
			pkg install curl git python zsh -y
			printf "\033[1;34m[ ] installing packages: complete\033[0m\n"
			
			zshSetup
			
			printf "\033[1;34m[-] setup oh-my-zsh with p10k: complete\033[0m\n"
		fi

		if [ $dc2 != "no" ];
		then
			printf "\033[1;34m[-] setup additional packages\033[0m\n"

			# packages
			printf "\033[1;34m[ ] installing packages\033[0m\n"			
			pkg install cmatrix espeak neofetch net-tools nmap openssh tty-clock -y
			printf "\033[1;34m[ ] installing packages: complete\033[0m\n"

			sshd
			
			printf "\033[1;34m[-] setup additional packages: complete\033[0m\n"
		fi

		if [ $dc3 != "no" ];
		then
			printf "\033[1;34m[-] setup termux configuration and font\033[0m $dc3\n"
			
			if [ ! -e ~/.termux/termux.properties/termux.properties || ! -e ~/.termux/font.ttf || $dc3 = "overwrite" ];
			then				
				printf "\033[1;34m[ ] downloading config files\033[0m\n"
				
				if [ ! -e ~/.termux/termux.properties/termux.properties || $dc3 = "overwrite" ];
				then
					curl --silent -output ~/.termux/termux.properties https://raw.githubusercontent.com/stefanableitinger/pointhub/master/termux.properties
				fi

				if [ ! -e ~/.termux/font.ttf || $dc3 = "overwrite" ];
				then
					curl --silent --output ~/.termux/font.ttf https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/AnonymousPro/complete/Anonymice%20Nerd%20Font%20Complete%20Mono.ttf
				fi

				termux-reload-settings
				
				printf "\033[1;34m[ ] downloading config files: complete\033[0m\n"
			fi
			
			printf "\033[1;34m[-] setup termux configuration and font: complete\033[0m $dc3\n"
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
#test
