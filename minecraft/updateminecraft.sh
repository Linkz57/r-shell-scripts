#!/bin/bash
cd /home/[username]/minecraft/server
rm ../minecraft_server.jar.bak* -I -v
cp minecraft_server.jar ../minecraft_server.jar.bak_$(date +%m-%d-%y_%I-%M%P) -v -f -x -p
rm minecraft_server.jar -v
wget https://s3.amazonaws.com/MinecraftDownload/launcher/minecraft_server.jar? -v -t 3 -T 30
echo -e "\n\n           ~ ~ U p d a t e   C o m p l e t e ! ~ ~ \n\n"