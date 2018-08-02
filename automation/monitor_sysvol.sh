#!/bin/bash
## monitor_sysvol.sh
## make a hash of all files in SYSVOL and compare it to the previous hash, which we assume happened last hour.
## Email a human if anything changes.
##
## version 1.1

mailaddress="me@domain.biz"
workingDirectory="${0%/*}"
SCRIPTPATH=`pwd -P`/monitor_sysvol.sh



if cd $workingDirectory ; then
        true
else
        echo "Something is wrong that shouldn't ever be wrong. I, $(whoami), tried navigating to the directory $workingDirectory and failed. This should be a trivial task. I'm exiting without going any further. Please fix me." | mail -s "sysvol monitor is unable to monitor the sysvol" $mailaddress
        exit 1
fi



if [ -r /mnt/sysvol/*/Policies ] ; then
        if mv -f $workingDirectory/sysvol.sha1 $workingDirectory/sysvol.sha1.lasthour ; then
                true
        else
                printf "If this is your first time running this script, then everything's fine.\n\nIf not, then this script or its environment is damaged in some way.\nI tried renaming the current sysvol hash to a new filename, and it failed.\nThis is normal if the file doesn't exist because I've never run before.\n\nI'm a script named $SCRIPTPATH running on $(hostname) as the user $(whoami) and I think it's $(date). \nI'm going to keep running, on the off chance this isn't a sign of breakage." | mail -s "sysvol monitor is probably unable to monitor the sysvol" $mailaddress
        fi



        if find /mnt/sysvol/ -type f -exec sha1sum {} \; | sort -k 2  > $workingDirectory/sysvol.sha1 ; then
                if diff $workingDirectory/sysvol.sha1 $workingDirectory/sysvol.sha1.lasthour > /dev/null ; then
                        exit 0
                else
                        printf "Files in the sysvol have changed\n\nIf you just updated a GPO then don't panic, the changes you made are being reflected\n\nIf you didn't knowingly edit a GPO between $(date) and an hour before then, now is a good time to panic.\nSome backups are located in smb://foo@bar/backups\nAlso be aware that someone might be mucking around your domain in an unauthorized fassion. It might be time to rotate your keys, change your passwords, and audit your security. \n\nAnyway, here's a list of each file that was changed. AoE means a file was Added or Edited while a Del means a file was Deleted in the last hour. If a file is listed as both Del and AoE then it was edited.\n\n$(diff $workingDirectory/sysvol.sha1 $workingDirectory/sysvol.sha1.lasthour | grep /mnt/sysvol | awk -F' ' '{print $1 "\t" $3 " " $4 " " $5 " " $6 " " $7 }' | sed 's/>/AoE/g' | sed 's/</Del/g' | sort -k 2 )\n\n" | mail -s "SUPER IMPORTANT - sysvol has changed" $mailaddress
                        exit 0
                fi
        else
                echo "Something is wrong that shouldn't ever be wrong. I, $(whoami), tried writing to a file in $workingDirectory and that failed. Please fix me" | mail -s "sysvol monitor is unable to monitor the sysvol" $mailaddress
                exit 1

        fi




        if [ -w $workingDirectory/sysvol.sha1 ] ; then
                true
        else
                echo "Something is wrong that shouldn't ever be wrong. I, $(whoami), tried writing to a file in $workingDirectory and that failed. Please fix me" | mail -s "sysvol monitor is unable to monitor the sysvol" $mailaddress
                exit
        fi
else
        echo "make sure your domain's SYSVOL share is mounted to /mnt/sysvol and accessable by $(whoami)" | mail -s "sysvol monitor is unable to monitor the sysvol" $mailaddress
        exit 1
fi
