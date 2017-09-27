#! /bin/bash

# preset values
iface="en0"
ip="$1"
snIndex="0"

# TODO: write a getopts that changes above values

# assign variables after options are parsed
allSubnets=($(ifconfig $iface | grep "inet " | cut -d " " -f 2 | cut -d . -f 1-3))
subnet=${allSubnets[$snIndex]}

if [ "$ip" != "" ]; then
	if [ $ip -ge 2 -a $ip -le 255 ]; then
		open -a "Google Chrome" 'http://10.38.0.'$ip'/Zuul/native'
		echo "Opening zuul native page...."
	else
		echo "ERROR: Value provided is not a valid number."
	fi
else
	echo "ERROR: Gateway IP not provided. Please provide the last octet of the gateway's local IP."
fi
