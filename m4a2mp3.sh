#!/bin/bash
#    m4a to mp3 files converter.
#    Copyright (C) <2012>  <Adrian 'aesptux' Espinosa>
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

echo "Dependencies: mplayer and lame"
if [ $# -lt 1 ]; then
	echo "Usage: sh m4a2mp3.sh '/path/to/files'"
else 
	echo "This could take sometime. Converting to 320kbps MP3 files..."
	sleep 1
	cd "$1"
	for i in *.m4a; do mplayer -ao pcm "$i" -ao pcm:file="$i.wav"; done
	for i in *.wav; do lame -h -b 320 "$i" "$i.mp3"; done
	echo "Cleaning the house..."
	rm -rf *.m4a
	rm -rf *.wav
fi
echo "All files converted. Thank you."