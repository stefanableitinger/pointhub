# .bashrc

# If not running interactively, don't do anything
#[[ $- != *i* ]] && return

#PS1='[\u@\h \W]\$ '

#add del key functionality for st
printf '\033[?1h\033=' >/dev/tty

if [ $(whoami) = 'root' ]; then
	PS1="\[\033[7;31m\][\u@\h]\[\033[0;37m\] \[\033[1;37m\][\w]\[\033[0;37m\] "
else
	PS1="\[\033[7;37m\][\u@\h]\[\033[0;37m\] \[\033[1;37m\][\w]\[\033[0;37m\] "
fi

export EDITOR=nvim
