#!/bin/bash
sh -c 'sleep 0.5; xdotool type "$(qdbus org.kde.klipper /klipper getClipboardContents)"'
## This assumes that Klipper is running on KDE5 and that xdotool is installed. Might also work in KDE4. 
## Klipper running is not the same as the default plasma clipboad widget. Close that and open Klipper instead. 
## instead of invoking this as a shell script, I'd recommend making it a 'custom global shortcut'

## thanks to Alex L. at https://askubuntu.com/questions/212154/create-a-custom-shortcut-that-types-clipboard-contents
## thanks also to OneLine at https://www.kubuntuforums.net/showthread.php?68017-CLI-for-Plasma-5-Clipboard
