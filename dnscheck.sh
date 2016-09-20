#!/bin/bash
#
# Written by Tyler Francis on 2016-09-20
# Make sure a given name resolves to a given address
# Version 1

name=mahserver
address=123.456.789.0
alertEmail=tyler.francis@jelec.com

hostname=`hostname`

# Thanks to T.J Crowder for the SCRIPTPATH variable
# https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
SCRIPTPATH=`pwd -P`/$name



if ping -c 4 $name | grep "$address"; then
	echo "$name seems both alive and resolving as expected"
else
	if ping -c 4 $address | grep ", 0% packet loss"; then
		echo "You should check your DNS server, and make sure $name resolves to $address. If I'm wrong or wasting your attention, feel free to edit me at $SCRIPTPATH on $hostname" | mail -s "I think the $name server is online, but not resolving in DNS as expected" $alertEmail
	else
		echo "This is a problem, I think. If I'm wrong or wasting your attention, feel free to edit me at $SCRIPTPATH on $hostname" | mail -s "I think the $name server is offline" $alertEmail
	fi
fi
