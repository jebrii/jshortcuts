# /bin/bash

# preset values

ip="$1"
file="$2"
subnet=$(ifconfig en0 | grep "inet " | cut -d " " -f 2 | cut -d . -f 1-3)
key="/Users/henryr/.ssh/keys/candi4k"
user="root"

# write a getopts that changes above values

if [ $ip -ge 2 -a $ip -le 255 ]; then
	while true; do
		ping -c 1 $subnet.$ip
		if [ $? -eq 0 ]; then
			break
		else
			sleep 30
		fi
	done
	if [ "$file" == "" ]; then
		echo "Enter the path to the file you want: "
		read file
	fi
	scp -i $key "$user@$subnet.$ip:$file" .
else
	echo "Please gimme a valid ip!"
	exit 1
fi
