#!/bin/bash

## service_check.sh
## version 1.1
## Written by Tyler Francis on 2016-09-27 for Jelec USA.

## A list of everyone you want to email when a problem occurs, separated by spaces.
alertEmail="me@jelec.com"

## How often do you want to receive emails about the same event? Measured in seconds
frequency=3600

## remove the old log, since it was probably already emailed out.
## the leading slash makes sure no goofy aliases of rm are being used.
\rm service_check.log

function checkNxfilter {
	## Check the machine in question to make sure NxFilter is running
	## Do this by SSH-ing in just long enough to ask systemd for a 0 (no error, AKA success) or 1 (error)
	## Since NxFilter does some DNS work for us, I can't trust hostname resolution, so I'll use the IP instead.
	if ssh $3@$2 "systemctl is-active nxfilter.service" ; then
		echo "NxFilter seems fine on $1." >> service_check.log
#		return 0
	else
		## section header for email
		echo "Problem found with Nx Filter on $1." >> service_check.log
		echo "`\date +%Y/%m/%d\ %H:%M`" >> service_check.log
		echo "________" >> service_check.log
		
		## Let's make sure I can actually see the server, and use that to compose the body of this section.
		if ping -c 4 $2 | grep ", 0% packet loss" ; then
			printf "The server $1 seems to be on, resolving to its expected address of $2, and responding to pings, but its service Nx Filter is not running.\n\nYou should either reboot the whole server, or SSH in and run\nsudo systemctl start nxfilter.service\n\nYou can also run systemctl status nxfilter.service to see a few log lines and figure out what broke." >> service_check.log
		else
			printf "I can't reach $1, so I can't tell if Nx Filter is running; let's assume it isn't.\n\nYou should either reboot the whole server, or SSH in and run\nsudo systemctl start nxfilter.service\n\nYou can also run systemctl status nxfilter.service to see a few log lines and figure out what broke." >> service_check.log
		fi
	fi
	
	## make some room at the end of a section, to make the text file more human-friendly
	echo "" >> service_check.log
	echo "" >> service_check.log
	echo "" >> service_check.log
}

#returnValue=($?)


## now that the function has been defined, run it using the following three arguments each separated by a single space.
## Function # hostname # ip address # username
checkNxfilter mahserver 123.456.7.8 username
checkNxfilter urserver 987.6.54.321 username
## argument       $1          $2        $3


## now use that text file I was creating during each running of the function as the body of an email.
## but only if an actual error was found.
if cat service_check.log | grep "Problem found" ; then
	## To make sure I'm not inundated with email or sms notifications, 
	## only send a notification at the frequency specified at the beginning of this script.
	if test -e "emailFrequency.txt" ; then
		## This file exists, meaning this is an ongoing problem.
		read first < emailFrequency.txt
		now=`\date +%s`
		if [[ $(($now - $first)) < $frequency ]] ; then
			## if this is true, then the specified time has elapsed, and another email should be sent.
			cat service_check.log | mail -s "Error: Some important services aren't running" $alertEmail
		else
			echo "wait longer"
			exit 0
		fi
	else
		## this is the first occurrence of this issue. Start a counter and email the humans. 
		echo `\date +%s` > emailFrequency.txt
		cat service_check.log | mail -s "Error: Some important services aren't running" $alertEmail
	fi
	
else
	## Remove the email frequency counter.
	## This bit only runs if none of the above servers failed their checks,
	## which means either the previous problem was fixed, or there was no previous problem.
	\rm emailFrequency.txt
	## TODO: first check if this file exists (meaning there used to be a problem) and if so send an email saying the issue cleared up, like Nagios does.
fi



## on Debian, I set up the mailer with
##   apt install exim4-daemon-light mailutils && dpkg-reconfigure exim4-config
## now I can pipe things to "mail" and it works great.
