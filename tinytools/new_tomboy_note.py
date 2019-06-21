#!/usr/bin/env python
## Thanks to Ryan Paul for pretty much all of this. I know nothing about Python
## https://arstechnica.com/information-technology/2007/09/using-the-tomboy-d-bus-interface/

import dbus, os

os.popen("/bin/sh -c 'if pgrep tomboy ; then exit ; else /usr/bin/tomboy & /bin/sleep 1 ; fi'")


bus = dbus.SessionBus()
obj = bus.get_object("org.gnome.Tomboy", "/org/gnome/Tomboy/RemoteControl")
tomboy = dbus.Interface(obj, "org.gnome.Tomboy.RemoteControl")


new_note = tomboy.CreateNote()
tomboy.DisplayNote(new_note)



## Below are supplemental files I use in my environment.
## First, the actual icon I might want to click.
#
#[Desktop Entry]
#Encoding=UTF-8
#Name=New Tomboy Note
#Comment=A script to create a new Tomboy note
#Type=Application
#Exec=~/scripts/new_tomboy_note.py
#Icon=tomboy
#Categories=Office


## Second: KWIN rules to improve the experience.
## For example: if I run my alias "note" from the command line,
## I want the new Tomboy note to be focused, rather than what I usually want,
## which is the terminal remaining focused.
#
#[Application settings for tomboy]
#Description=Application settings for tomboy
#above=true
#aboverule=3
#clientmachinematch=0
#fsplevel=0
#fsplevelrule=2
#wmclass=tomboy
#wmclasscomplete=false
#wmclassmatch=1
