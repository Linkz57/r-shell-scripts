#!/bin/sh
#start.sh v1
sudo cryptsetup luksOpen /dev/sda2 mahdrive
sudo udisks --mount /dev/mapper/mahdrive
nohup rhythmbox &
sleep 5
