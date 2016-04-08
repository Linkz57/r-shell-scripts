mahip=$(ipconfig| grep '192.168.'| grep -v 'Default Gateway' | cut -d: -f2 | awk '{ print $1}')

while true
do
	ping -n 1 computer-name-1 | grep Reply | grep -v $mahip
	ping -n 1 computer-name-2 | grep Reply | grep -v $mahip
	echo done
	sleep 1m
done
