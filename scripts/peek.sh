#! /bin/bash

config_vars=$(bash "$JSHOR/resources/sanitize.sh" "$JSHOR/resources/.jshor_config")
eval "$config_vars"

if [ $# -eq 2 ] ; then
	cmd='-t "'$2'; bash -l"'
	echo "cmd = \"$cmd\""
else
	cmd=""
fi

# TODO: write a getopts that changes above values

subnet=$(bash "$JSHOR/resources/findSubnet.sh" $snIndex $iface)
if [ -z "$subnet" ]; then
	echo -e "${RED}ERROR: could not find valid subnet.${NC}" >&2
	exit 1
fi

if [ $ip -ge 2 -a $ip -le 255 ]; then
	while true; do
		ping -c 1 $subnet.$ip
		if [ $? -eq 0 ]; then
			break
		else
			sleep 30
		fi
	done
	open -a "Google Chrome" "http://$subnet.$ip"
else
	echo -e "${RED}ERROR: Value provided is not a valid number.${NC}" >&2
fi
