
date_formatted=$(date "+%Y-%m-%d %H:%M:%S %p")
localip=$(ifconfig | grep broadcast | awk '{print $2}')

echo $date_formatted $localip
