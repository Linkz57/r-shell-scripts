r-shell-scripts
===============

Unix shell scripts. Aiming to make mundane and frequent tasks slightly easier. Written for Bash on Ubuntu.

What's in the repo
------------------
The following directories:

- minecraft -- Separate scripts to backup, update and launch a Minecraft server.  

    - The launch script is copied verbatim from minecraft.net and is fairly boring.
    - The backup script is used to copy the whole Minecraft server directory to a server via rsync. My NAS runs an rsync daemon, which is good because I still can't figure out how to FTP a directory over from a shell script. To use this script on your own machine, you'll have to change some bits like the location of your minecraft folder, server IP, server credentials, and the names of folders. If I was half as skilled as [Ahtenus](https://github.com/Ahtenus/minecraft-init "minecraft-init") I would have used variables to make the setup easier, but I'm not so I didn't.
    - The update script is fairly simple, but probably saves the most time out of all three.

 
- tempmon -- Monitor system temperature with lm-sensors & hddtemp.

    - First install and configure with ``sudo apt-get install lm-sensors hddtemp && sudo sensors-detect``
    - Then run ``sudo ./temp.sh``. It has to be run as root because hddtemp requires root. I'm a noob, and while I know that things should not be run as root when they don't absolutely *have* to be, I still haven't been burned bad enough to care. Therefore, both watch and sensors run as root, though they don't need it.
    - temp.sh assumes that sensors.sh is in the same directory. There's probably a way to compact this into one script, but I don't know how, and this works well for me.


Things I'd like to add
------------------
- I'd like to automatically append the Minecraft server version number to the backups. I might be able to grep out the third line of what the minecraft jar prints to the console, or maybe scrape the Minecraft Tumblr feed or something like that. 