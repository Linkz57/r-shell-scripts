#!/bin/bash
## change_activities_plasma5.sh
## version 0.6
## Basically I want to change to different Plasma 'Activity' if my laptop is docked, which it usually is.
## If I'm not docked I'm probably on battery, so stop the docked activity which will probably save power.
## My "Mobile" activity has a very low brightness, and thanks to Latte-Dock has a small panel on the side of the screen with aggressive auto-hiding.
## My "Work" or 'docked' activity has a permanent panel on the bottom of the screen
## Apparently Plasma 5 doesn't have any options to switch activities on power mode, so I'm switching on display server resolution which is closer to what I want anyway.


#sleep 60

resolution="$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')"
## Thanks to user31752 for the above xdpyinfo and its pipes
## https://superuser.com/questions/196532/how-do-i-find-out-my-screen-resolution-from-a-shell-script


## while resolution is 4920x1920

if [ "$resolution" = "4920x1920" ] ; then
	qdbus org.kde.ActivityManager /ActivityManager/Activities SetCurrentActivity "3a665e75-72b2-4f8f-8d85-11d48910c315" ## switch to "Work"
elif [ "$resolution" = "3840x1080" ] ; then
	qdbus org.kde.ActivityManager /ActivityManager/Activities SetCurrentActivity "3a665e75-72b2-4f8f-8d85-11d48910c315" ## switch to "Work"
elif [ "$resolution" = "5206x1080" ] ; then
	qdbus org.kde.ActivityManager /ActivityManager/Activities SetCurrentActivity "3a665e75-72b2-4f8f-8d85-11d48910c315" ## switch to "Work"
else
		      #        "    ""#          
	#mmmm   mmm   #mmm   mmm      #     mmm  
	# # #  #" "#  #" "#    #      #    #"  # 
	# # #  #   #  #   #    #      #    #"""" 
	# # #  "#m#"  ##m#"  mm#mm    "mm  "#mm" 

	qdbus org.kde.ActivityManager /ActivityManager/Activities SetCurrentActivity "69b75789-fe77-4c94-81a6-7c02b599da0d" ## switch to "Mobile"
	qdbus org.kde.ActivityManager /ActivityManager/Activities StopActivity "3a665e75-72b2-4f8f-8d85-11d48910c315" ## stop "Work" after switching
fi




## while resolution is 1366x768

#if [ "$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')" = "1366x768" ] ; then
#	qdbus org.kde.ActivityManager /ActivityManager/Activities SetCurrentActivity "69b75789-fe77-4c94-81a6-7c02b599da0d" ## switch to "Mobile"
#fi
