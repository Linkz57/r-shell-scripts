#!/bin/bash
cd /home/[username]/minecraft
cp -R -v server server\ backup/server.bak_$(date +%m-%d-%y_%I-%M%P) && ls -l --color server\ backup/server.bak_$(date +%m-%d-%y_%I-%M%P)
ls -l --color server\ backup
echo -e "\n\n           ~ ~ B a c k u p   C o m p l e t e ! ~ ~ \n\n"