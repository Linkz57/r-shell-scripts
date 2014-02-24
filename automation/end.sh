#!/bin/bash
wmctrl -c rhythmbox
sleep 2
killall rhythmbox
sleep 2
sudo umount /media/69ee332c-0039-4c2d-93e9-8e397d4857b2/
sudo cryptsetup luksClose mahdrive
sleep 10
sudo shutdown -h now
