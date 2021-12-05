# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#PS1='[\u@\h \W]\$ '

if [ $(whoami) = 'root' ]; then
	PS1="\[\033[1;31m\][\u@\h] \[\033[7;34m\][\w]\[\033[0;37m\] "
else
	PS1="\[\033[1;32m\][\u@\h] \[\033[7;34m\][\w]\[\033[0;37m\] "
fi
