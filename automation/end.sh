#!/bin/bash
# end.sh v1.2
wmctrl -c rhythmbox
sudo ls > /dev/null
sleep 2
killall rhythmbox
sleep 2
sudo umount /media/69ee332c-0039-4c2d-93e9-8e397d4857b2/
sudo cryptsetup luksClose mahdrive
echo "done with all of that. Shutting down, now"
sleep 10
sudo shutdown -h now
