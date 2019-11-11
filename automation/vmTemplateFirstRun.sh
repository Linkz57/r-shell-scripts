#!/bin/bash
## vmTemplateFirstRun.sh
## Version 2.4
##
## I want to run this script to safely make a clone of a machine
## and I want this clone to live safely on the same network with many of its other clones, concurrently
## I think all I have to do is change the hostname, IP, MAC, and ssh keys.
## I want to do this automatically on each boot, only if the hostname is "templatemachn" which is what I've named my template OS.
## Stick ./vmTemplateFirstRun.sh at the end of your .bashrc file and save this script in your home directory.
## Then backup or make a template of this machine. All future instantiations will run this once on login, then reboot themselves. On next login this script will be auto deleted.
## This was written for Ubuntu 16.04.03 but will probably work on any Debain-based distro.


## ask user for desired hostname and IP settings
if hostname | grep -P '(^|\s)\Ktemplatemachn(?=\s|$)' > /dev/null ; then
	echo "Which hostname do you want this machine to use?"
	read hname

	usedIP=true
	while $usedIP ; do
		echo "Which IP address do you want this machine to use?"
		read iaddress

		badIP=false
		if echo $iaddress | grep -v "^[0-9.]*$" ; then
			echo "I just want the IP address as formatted like 127.0.0.1 just numbers and periods."
			echo "I'll assume you want a /24 subnet mask, and if you don't then you can change it manually at the end of this script."
			badIP=true
		fi

		if $badIP ; then
			usedIP=true
		else
			if ping -c 1 $iaddress >/dev/null ; then
				echo "I just pinged that IP and it's currently on the network."
				echo "Do you want to make a possibly terrible choice and keep going with $iaddress ?"
				sleep 3
				echo "(y/N)"
				read yesorno
				case $yesorno in
					y ) usedIP=false
					;;
				esac
			else
				usedIP=false
			fi
		fi
	done

	echo "Making your changes..."

	## change hostname
	echo "Chaning hostname..."
	sudo cp /etc/hostname /etc/hostname.$(\date +%Y-%m-%d_%H-%M).bak
	echo $hname | sudo tee /etc/hostname
	sudo cp /etc/hosts /etc/hosts.$(\date +%Y-%m-%d_%H-%M).bak
	sudo sed -i 's/templatemachn/'"$hname"'/g' /etc/hosts


	## set up static IP
	## find a working NIC
	workingNics=$(ip link | grep "<BROADCAST,MULTICAST,UP,LOWER_UP>" | awk -F'[ :]' '{print $3}')
	echo "I found the following NICs are plugged in and ready to roll, but if there's more than one I'm just going to use the first."
	echo "$workingNics"
	workingNicsFirst=$(echo "$workingNics" | head -n1)
	if [ -d /etc/netplan ] ; then
		echo "Changing IP address for this Ubuntu 18.04 or later machine..."
		sudo mv /etc/netplan/01-netcfg.yaml /etc/netplan/01-netcfg.yaml.original
		printf "network:\n  version: 2\n  renderer: networkd\n  ethernets:\n    $workingNicsFirst:\n      addresses: [ $iaddress/24 ]\n      gateway4: $(echo $iaddress | awk -F "." '{print $1}').$(echo $iaddress | awk -F "." '{print $2}').$(echo $iaddress | awk -F "." '{print $3}').1\n      nameservers:\n          search: [ mahworkgroup.egg ]\n          addresses:\n              - \"10.0.0.1\"\n              - \"10.0.0.2\"\n              - \"10.0.0.3\"" | sudo tee /etc/netplan/01-netcfg.yaml
	else
		echo "Changing IP address for this Ubuntu 16.04 or earlier machine..."
		sudo cp /etc/network/interfaces /etc/network/interfaces.$(\date +%Y-%m-%d_%H-%M).bak
		firstBitOfInterfaces=$(head /etc/network/interfaces -n$(grep -n "inet static" /etc/network/interfaces | awk -F ':' '{ print $1 }'))
		echo "$firstBitOfInterfaces" | sudo tee /etc/network/interfaces
		echo "address $iaddress" | sudo tee -a /etc/network/interfaces
		echo "netmask 255.255.255.0" | sudo tee -a /etc/network/interfaces
		echo "network $(echo $iaddress | awk -F "." '{print $1}').$(echo $iaddress | awk -F "." '{print $2}').$(echo $iaddress | awk -F "." '{print $3}').0" | sudo tee -a /etc/network/interfaces
		echo "broadcast $(echo $iaddress | awk -F "." '{print $1}').$(echo $iaddress | awk -F "." '{print $2}').$(echo $iaddress | awk -F "." '{print $3}').255" | sudo tee -a /etc/network/interfaces
		echo "gateway $(echo $iaddress | awk -F "." '{print $1}').$(echo $iaddress | awk -F "." '{print $2}').$(echo $iaddress | awk -F "." '{print $3}').1" | sudo tee -a /etc/network/interfaces
		echo "dns-nameservers 10.0.0.1" | sudo tee -a /etc/network/interfaces
		echo "dns-search mahworkgroup.egg" | sudo tee -a /etc/network/interfaces
	fi
	


	## generate unique SSH keys
	echo "Generating unique SSH keys..."
	sudo rm /etc/ssh/ssh_host_*_key*
	sudo dpkg-reconfigure openssh-server


	echo "Rebooting in 5..."
	sleep 1
	echo "Rebooting in 4..."
	sleep 1
	echo "Rebooting in 3..."
	sleep 1
	echo "Rebooting in 2..."
	sleep 1
	echo "Rebooting in 1..."
	sleep 1
	echo "Blast off!"
	sudo reboot
else
	## del myself into pieces, this is my last rm
	## self-deleting, no changing
	## don't give a darn if an inode's hanging
	sed -i 's/\.\/vmTemplateFirstRun.sh//g' /home/toor/.bashrc
	rm -- "$0"
fi
