r-shell-scripts
===============

Unix shell scripts. Aiming to make mundane and frequent tasks slightly easier. Written for Bash on Ubuntu.

What's in the repo
------------------
The following directories:

- minecraft -- Separate scripts to backup, update and launch a Minecraft server.  

    - The launch script is copied verbatim from minecraft.net and is fairly boring.
    - The backup script is the first “fancy” script I've ever written in any language. It officially crosses the “fancy” threshold with its $(date +%m-%d-%y_%I-%M%P) bit; I found that variable out there on the internet and it was love at first grok. That ls command at the end of line 3 needs work. Any of the many smarter scripters could take one look at that and tell that starting a backup at the end of a minute will cause the ls to fail. One of these days I'll learn regular expressions and fix it, but until then I'm fine with line 3.5 *usually* working. 
    - The update script is fairly simple, but probably saves the most time out of all three.
    
- tempmon -- Monitor system temperature with lm-sensors & hddtemp.

    - First install and configure with ``sudo apt-get install lm-sensors hddtemp && sudo sensors-detect``
    - Then run ``sudo ./temp.sh``. It has to be run as root because hddtemp requires root. I'm a noob, and while I know that things should not be run as root when they don't absolutely *have* to be, I still haven't been burned bad enough to care. Therefore, both watch and sensors run as root, though they don't need it.
    - temp.sh assumes that sensors.sh is in the same directory. There's probably a way to compact this into one script, but I don't know how, and this works well for me.


Things I'd like to add
------------------
- I wrote the $(date) variable before I read XKCD 1179, so one of these days I'll update my backup and update script to comply with ISO 8601
- I'd like to automatically append the Minecraft server version number to the backups. I might be able to grep out the third line of what the minecraft jar prints to the console, or maybe scrape the Minecraft Tumblr feed or something like that. 