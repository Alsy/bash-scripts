#!/bin/bash
#    Reset all NICs, in case you're having problems (i.e cloned VMs)
#    Copyright (C) <2012>  <Adrian Espinosa>
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

if [ $UID -ne 0 ] 
then
	echo "Sorry, you have to run this script as root"
else
	cat /etc/udev/rules.d/70-persistent-net.rules | grep PCI | cut -d' ' -f5 | cut -b 2-6 | uniq > /tmp/drivers
	for driver in $(cat /tmp/drivers); do
		rm -rf /etc/udev/rules.d/70-persistent-net.rules && echo "Removing 70-persistent-net.rules"
		rmmod $driver && echo "Removing $driver"
		modprobe $driver && echo "Loading $driver"
	done
	echo "Done."
	rm -rf /tmp/drivers
fi
