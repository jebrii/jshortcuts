#! /bin/bash

source "/Users/henryr/.bash_profile"

config_vars=$(bash "$JSHOR/resources/sanitize.sh" "$JSHOR/resources/.jshor_config")
eval "$config_vars"

# local variables
set_default='false'

if [ -n "$1" -a "${1:0:1}" != "-" ] 2>/dev/null; then
	ip="$1"
	shift
	if [ -n "$1" -a "${1:0:1}" != "-" ] 2>/dev/null ; then
		uri='-t "'$1'; bash -l"'
		echo "uri = \"$uri\""
		shift
	fi
fi

# TODO: write a getopts that changes above values

if [ $set_default = 'true' ]; then
	subnet=$default_subnet
else
	subnet=$(bash "$JSHOR/resources/findSubnet.sh" $snIndex $iface)
fi
if [ -z "$subnet" ]; then
	echo -e "${RED}ERROR: could not find valid subnet.${NC}" >&2
	exit 1
fi

if [ $ip -ge 2 -a $ip -le 255 ] 2>/dev/null; then
	while true; do
		ping -c 1 $subnet.$ip
		if [ $? -eq 0 ]; then
			break
		else
			sleep 30
		fi
	done
	open -a "Google Chrome" "http://$subnet.$ip/$uri"
else
	echo -e "${RED}ERROR: Please provide a valid IP octet.${NC}" >&2
fi
