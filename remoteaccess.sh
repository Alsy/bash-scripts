#!/bin/bash
#    Find online hosts on your network, backup a directory and halt them
#    Copyright (C) <2011>  <Adrian Espinosa>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

clear
f=`echo networkscanned_$(date +%Y%m%d)`
me=`echo $(whoami)`
DIR="put_here_your_dir_to_sync"
DEST="put_here_your_destination"
if [ $UID -ne 0 ] 
then
	echo "Sorry, you have to run this script as root"
else
	net=`ip route show | grep / | cut -d " " -f1`
	echo "Please, wait while your network is scanned"
	completescan=`nmap -sP $net | grep "is up" | cut -d " " -f2`
	clear
	echo "$completescan" > $f
	gateway=`ip route show | grep via | cut -d " " -f3`
	cat $f | egrep -v `echo $gateway$` > /tmp/net
	cat /tmp/net > $f
	rm -rf /tmp/net
	ownip=`ip route show | grep src | cut -d " " -f12`
	cat $f | grep -v $ownip > /tmp/net
	cat /tmp/net > $f
	rm -rf /tmp/net
	echo "Starting synchronization"
	for host in $(cat $f) 
	do
		echo "Syncing with $host" 
		rsync --progress -avhe ssh $me@$host:$DIR $DEST &> backup.log
		ssh $me@$host "shutdown -h now" &> backup.log
	done
	echo "Done. You may check backup.log to see if there are any errors"
	rm -rf $f
	exit 0
fi



