#!/bin/sh
# created by stefan ableitinger on 20/apr/2021
# setup wizard

welcome () {
	printf "\033[1;34m           _                          _                  _  \033[m\n"
	printf "\033[1;34m  ___  ___| |_ _   _ _ __   __      _(_)______ _ _ __ __| | \033[m\n"
	printf "\033[1;34m / __|/ _ \ __| | | | |_ \  \ \ /\ / / |_  / _| | |__/ _| | \033[m\n"
	printf "\033[1;34m \__ \  __/ |_| |_| | |_) |  \ V  V /| |/ / (_| | | | (_| | \033[m\n"
	printf "\033[1;34m |___/\___|\__|\__|_| |__/    \_/\_/ |_/___\__|_|_|  \__|_| \033[m\n"
	printf "\033[1;34mby stefanableitinger|_|++                                   \033[m\n"
	printf "\n"
	}

complete() {
	printf "\033[1;34m           _                     _                    _  \033[m\n"
	printf "\033[1;34m  ___  ___| |_ _   _ _ __     __| | ___  _ __   ___  | | \033[m\n"
	printf "\033[1;34m / __|/ _ \ __| | | | |_ \   / _| |/ _ \| |_ \ / _ \ | | \033[m\n"
	printf "\033[1;34m \__ \  __/ |_| |_| | |_) | | (_| | (_) | | | |  __/ |_| \033[m\n"
	printf "\033[1;34m |___/\___|\__|\__,_| |__/   \__,_|\___/|_| |_|\___| (_) \033[m\n"
	printf "\033[1;34mhave a nice day!    |_|                                  \033[m\n"
	printf "\033[1;34mbye                                                      \033[m\n"
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
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh 2>/dev/null)" "" --unattended

		# plugins
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
		git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
		git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
		git clone git://github.com/wting/autojump.git ~/.oh-my-zsh/custom/plugins/autojump

		cd ~/.oh-my-zsh/custom/plugins/autojump/
		python install.py

		# config
		curl --silent --output ~/.zshrc https://raw.githubusercontent.com/stefanableitinger/pointhub/master/.zshrc
		curl --silent --output ~/.p10k.zsh https://raw.githubusercontent.com/stefanableitinger/pointhub/master/.p10k.zsh
		}

continueOrQuit () {
		printf "\033[1;34m[?]\033[0m press [\033[1;32mc\033[m] to continue or [\033[1;30mq\033[m] to quit.\n"
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
	printf "\033[1;34m[-]\033[0m press [\033[1;32my\033[m] to include [\033[1;31mn\033[m] to skip or [\033[1;30mq\033[m] to quit\n"

	while true; do
			readOne
			case $result in
					[yY]* )
							choice="yes"
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

		printf "\033[1;34m[?] setup font (spacemono-nf unzip wget)?\033[0m\n"
		includeSkipOrQuit
		dc4=$choice

		# check privileges
		if [ $(id -u) -ne 0 ];
		then 
			printf "\033[1;34m[?] root privileges required for setup\033[0m \n"
			sudo printf "" 2>/dev/null

			if [ "$?" = "1" ];
			then
				dcr="\033[1;31mno\033[0m"
			else
				dcr="yes"
			fi
		fi

		printf "\033[1;34m[!] root privileges granted: \033[0m $dcr\n"
		printf "\033[1;34m[!] setup oh-my-zsh with p10k: \033[0m $dc1\n"
		printf "\033[1;34m[!] setup i3-gaps with rofi: \033[0m $dc2\n"
		printf "\033[1;34m[!] setup additional packages: \033[0m $dc3\n"
		printf "\033[1;34m[!] setup font: \033[0m $dc4\n"

		continueOrQuit
		printf "\033[1;34m[!] setup starting \033[0m $ac3\n"

		if [ "$dc1" = "yes" ]
		then
			sudo apt install curl git python zsh -y

			zshSetup
		fi

		if [ "$dc2" = "yes" ]
		then
			sudo apt install feh i3-gaps mugshot picom rofi xfce4-terminal -y

			# avatar
			mkdir --parents ~/Pictures
			curl --silent --output ~/Pictures/k.png https://avatars.githubusercontent.com/u/56166006

			# config
			mkdir --parents ~/.config/i3
			curl --silent --output ~/.config/i3/config https://raw.githubusercontent.com/stefanableitinger/pointhub/master/i3_config
			curl --silent --output ~/.config/i3/i3_status.sh https://raw.githubusercontent.com/stefanableitinger/pointhub/master/i3_status.sh

			# wallpapers
			mkdir --parents ~/.local/share/backgrounds
			curl --silent --output-dir ~/.local/share/backgrounds https://raw.githubusercontent.com/stefanableitinger/pointhub/master/innere-stadt.png
			curl --silent --output-dir ~/.local/share/backgrounds https://raw.githubusercontent.com/stefanableitinger/pointhub/master/innere-stadt-lockscreen.png

			curl --silent --output ~/.local/share/backgrounds https://raw.githubusercontent.com/stefanableitinger/pointhub/master/fedora.png
			curl --silent --output ~/.local/share/backgrounds https://raw.githubusercontent.com/stefanableitinger/pointhub/master/fedora-lockscreen.png			

			curl --silent --output ~/.local/share/backgrounds https://raw.githubusercontent.com/stefanableitinger/pointhub/master/ubuntu.png
			curl --silent --output ~/.local/share/backgrounds https://raw.githubusercontent.com/stefanableitinger/pointhub/master/ubuntu-lockscreen.png
		fi

		if [ "$dc3" = "yes" ]
		then
			sudo apt install asciiart cmatrix endlessh firejail fail2ban neofetch net-tools nmap openfortivpn remmina samba tty-clock -y

			sudo mkdir --parents /etc/samba
			sudo curl --silent -O --output-dir /etc/samba/ https://raw.githubusercontent.com/stefanableitinger/pointhub/master/smb.conf

			sudo mkdir -p /etc/endlessh
			sudo curl --silent --output /etc/endlessh/config https://raw.githubusercontent.com/stefanableitinger/pointhub/master/endlessh_config
		fi

		if [ "$dc4" = "yes" ]
		then
			mkdir --parents ~/.local/share/fonts/spacemono-nf 
			curl --silent --output ~/.local/share/fonts/spacemono-nf/Space%20Mono%20Nerd%20Font%20Complete%20Mono.ttf https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SpaceMono/Regular/complete/Space%20Mono%20Nerd%20Font%20Complete%20Mono.ttf
			fc-cache -rf ~/.local/share/fonts/spacemono-nf 
		fi
		}

startServices () {
		if [ "$dc3" = "yes" ]
		then
			sudo systemctl enable smbd.service
			sudo systemctl start smbd.service

			sudo systemctl enable endlessh.service
			sudo systemctl start endlessh.service
			sudo systemctl enable fail2ban.service
			sudo systemctl start fail2ban.service
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

		if [ "$dc1" = "yes" ];
		then
			pkg install curl git python zsh -y

			zshSetup
		fi

		if [ "$dc2" = "yes" ];
		then
			pkg install cmatrix espeak neofetch net-tools nmap openssh tty-clock -y

			sshd
		fi

		if [ "$dc3" = "yes" ];
		then
			curl --silent -O --output-dir ~/.termux https://raw.githubusercontent.com/stefanableitinger/pointhub/master/termux.properties

			cp ~/.termux/font.ttf ~/.termux-font-backup.ttf
			curl --silent --output ~/.termux/font.ttf https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/AnonymousPro/complete/Anonymice%20Nerd%20Font%20Complete%20Mono.ttf
			
			termux-reload-settings
		fi
		}

main () {
	welcome

	if [ $(uname -o) = "Android" ];
	then
		printf "\033[1;34m android os detected\033[m\n"
		continueOrQuit
		androidSetup
		if [ "$dc1" = "yes" ];
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

                if [ "$dc1" = "yes" ];
                then
                        sudo chsh -s zsh
                fi

		complete
	fi
	}

main
