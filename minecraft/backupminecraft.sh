#!/bin/bash
cd /home/[username]/minecraft
rsync -av server [username]@[ServerIP]::[folder]/minecraftbackups/server.bak_$(date +%Y-%m-%d_%H-%M)
echo -e "\n\n           ~ ~ B a c k u p   C o m p l e t e ! ~ ~ \n\n"