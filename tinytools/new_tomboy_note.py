#!/usr/bin/env python
## This is a Python 2 script, the vast majority of which I didn't write.
##
## Thanks to Ryan Paul for pretty much all of this. I know nothing about Python
## https://arstechnica.com/information-technology/2007/09/using-the-tomboy-d-bus-interface/
##
## except for the two datetime lines, which came from Eliot
## https://www.saltycrane.com/blog/2008/06/how-to-get-current-date-and-time-in/

import dbus, os, datetime

now = datetime.datetime.now()

os.popen("/bin/sh -c 'if pgrep tomboy ; then exit ; else /usr/bin/tomboy & until pgrep tomboy ; do sleep .2 ; done ; sleep .5 ; fi'")


bus = dbus.SessionBus()
obj = bus.get_object("org.gnome.Tomboy", "/org/gnome/Tomboy/RemoteControl")
tomboy = dbus.Interface(obj, "org.gnome.Tomboy.RemoteControl")


new_note = tomboy.CreateNote()
tomboy.DisplayNote(new_note)
tomboy.SetNoteContents(new_note,"Thinkin bout stuff - " + str(now.strftime("%Y-%m-%d %H:%M")) + "\n\n")


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
