#/bin/bash
#    Get ip from given domains or from a GReader .opml .
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

	echo "**************************************"
	echo " -- GET IP -- "
	echo " By aesptux"
	echo " http://mortuux.wordpress.com"
	echo "**************************************"
	echo " "
	echo " "
	echo "Please, enter your input method: "
	echo "1 - Single url"
	echo "2 - Text file"
	echo "3 - Google Reader OPML file"
	read opt
	case $opt in 
		1) 
			echo "Type your url:"
			read url
			ip=`host $url | grep address | cut -d " " -f 4` 
			echo "$url --> $ip"
		;;
		2) 
			echo "Type the path of the file to import:"
			read f
			for line in $(cat $f); do
				ip=`host $line | grep address | cut -d " " -f 4`
				echo "$line --> $ip" >> your_urls_ip
			done
			echo "A text file has been generated with the ip's of the urls you've entered."
		;;
		3)
			echo "Type the path of the OPML file: "
			read opml
			echo "Parsing file..."
			echo "$(cat $opml)" | grep htmlUrl  > /tmp/parsedfile # We start selecting urls. First a 'grep htmlUrl' because we're interested in the url
			sed 's/http:\/\// /g' /tmp/parsedfile > parsedfile # We delete http://. Maybe it's confusing. In regular expressions for being able to replace '/' we have to escape it with '\'.
			sed 's/https:\/\// /g' parsedfile > parsedfile2 #We delete https://
			sed 's/type="rss"/ /g' parsedfile2 > parsedfile3 # In some lines, appeared type=rss, so the document didn't follow the same structure, so we remove it
			sed 's/...$/ /' parsedfile3 > parsedfile4 # We delete the last three characters, which were an xml tag
			
			cat parsedfile4 | sed -e 's/^[ \t]*//' | cut -d " " -f 4 > fileparsed # We delete the first tab.
			for line in $(cat fileparsed); do
				if [[ $line == */ ]]; then 
					echo $line | sed 's/.$/ /' >> final #If the url ends with '/' we remove it
				else
					echo $line >>final
				fi
			done
			echo "Working.. This may take several minutes, depending on the number of websites."
			for line in $(cat final); do
				ip=`host $line | grep address | cut -d " " -f 4`
				echo "$line --> $ip" >> your_urls_ip
			done
			echo "A text file has been generated with the ip's of the urls you've imported."
			rm -rf fileparsed parsedfile parsedfile2 parsedfile3 parsedfile4 final # delete temp files
		;;
		*)
			echo "Choose a valid option"
	esac

