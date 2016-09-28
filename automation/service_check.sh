#!/bin/bash

## service_check.sh
## version 1.4
## Written by Tyler Francis on 2016-09-27 for Jelec USA.

## A list of everyone you want to email when a problem occurs, separated by spaces.
alertEmail="me@jelec.com"
alertSMS="555.555.foo@txt.voice.google.com"

## How often do you want to receive emails about the same event? Measured in seconds
frequency=3600

## remove the old log, since it was probably already emailed out.
## the leading slash makes sure no goofy aliases of rm are being used.
\rm service_check.email
\rm service_check.sms

function checkNxfilter {
	## Check the machine in question to make sure NxFilter is running
	## Do this by SSH-ing in just long enough to ask systemd for a 0 (no error, AKA success) or 1 (error)
	## Since NxFilter does some DNS work for us, I can't trust hostname resolution, so I'll use the IP instead.
	if ssh $3@$2 -o ConnectTimeout=10 -o BatchMode=yes "systemctl is-active nxfilter.service" ; then
		echo "NxFilter seems fine on $1." >> service_check.email
	else
		## section header for email
		echo "Problem found with Nx Filter on $1." >> service_check.email
		echo "Problem found with Nx Filter on $1." >> service_check.sms
		echo "`\date +%Y/%m/%d\ %H:%M`" >> service_check.email
		echo "________" >> service_check.email

		## Let's make sure I can actually see the server, and use that to compose the body of this section.
		if ping -c 4 $2 | grep ", 0% packet loss" ; then
			printf "The server $1 seems to be on, resolving to its expected address of $2, and responding to pings, but either SSH or Nx Filter is not running.\n\nYou should reboot the whole server." >> service_check.email
		else
			printf "I can't reach $1, so I can't tell if Nx Filter is running; let's assume it isn't.\n\nYou should either reboot the whole server, or SSH in and run\nsudo systemctl start nxfilter.service\n\nYou can also run systemctl status nxfilter.service to see a few log lines and figure out what broke." >> service_check.email
		fi
	fi

	## make some room at the end of a section, to make the text file more human-friendly
	echo "" >> service_check.email
	echo "" >> service_check.email
	echo "" >> service_check.email
	echo "" >> service_check.email
	echo "" >> service_check.email
	echo "" >> service_check.email
	echo "" >> service_check.email
}



## now that the function has been defined, run it using the following three arguments each separated by a single space.
## Function # hostname # ip address # username
checkNxfilter mahserver 123.456.7.8 username
checkNxfilter urserver 987.6.54.321 username
## argument       $1          $2        $3


## now use that text file I was creating during each running of the function as the body of an email.
## but only if an actual error was found.
if cat service_check.email | grep "Problem found" ; then
	## To make sure I'm not inundated with email or sms notifications,
	## only send a notification at the frequency specified at the beginning of this script.
	if test -e "emailFrequency.txt" ; then
		## This file exists, meaning this is an ongoing problem.
		read first < emailFrequency.txt
		now=`\date +%s`
		if [[ $(($now - $first)) < $frequency ]] ; then
			## if this is true, then the specified time has elapsed, and another email should be sent.
			cat service_check.email | mail -s "Error: Some important services aren't running" $alertEmail
			cat service_check.sms | mail $alertSMS
			## Now reset the counter, so another notification can be sent an hour or whenever from now.
			echo `\date +%s` > emailFrequency.txt
		else
			echo "wait longer"
		fi
	else
		## this is the first occurrence of this issue. Start a counter and email the humans.
		echo `\date +%s` > emailFrequency.txt
		cat service_check.email | mail -s "Error: Some important services aren't running" $alertEmail
		cat service_check.sms | mail $alertSMS
	fi

else
	## This bit only runs if none of the above servers failed their checks,
	## which means either the previous problem was fixed, or there was no previous problem. Let's find out which of those is true.
	if test -e "emailFrequency.txt" ; then
		## If there is no problem now, but the last time this script ran there was a problem, then a problem has been solved.
		echo "Success: all services monitored by service_check.sh have been restored" | mail -s "Success: all services monitored by service_check.sh have been restored" $alertEmail
		echo "Success: all services monitored by service_check.sh have been restored" | mail $alertSMS
	fi
	## Remove the email frequency counter.
	\rm emailFrequency.txt
fi



## on Debian, I set up the mailer with
##   apt install exim4-daemon-light mailutils && dpkg-reconfigure exim4-config
## now I can pipe things to "mail" and it works great.
##
## I configured exim4 to send mail via Gmail's SMTP servers
## I then set up a Google Voice account, which lets me send SMS messages via email.
## Once you set up a Google Voice number, by default, GV will send you an email when you receive an SMS
## Send a text from your cell to your new GV number, and you'll get an email from an address that looks like
## [your gv number].[number that just sent an SMS].[seemingly random characters]@txt.voice.google.com
## any email you send to that address from your Gmail account will be received as an SMS on your cell.
