#! /bin/bash

source "/Users/${USER}/.bash_profile"

config_vars=$(bash "$JSHOR/util/sanitize.sh" "$JSHOR/util/.jshor_config")
eval "$config_vars"

# local variables
addons=""
set_default='false'

if [ -n "$1" -a "${1:0:1}" != "-" ] 2>/dev/null; then
	ip="$1"
	shift
	if [ -n "$1" -a "${1:0:1}" != "-" ] 2>/dev/null ; then
		iface="$1"
		sn_index=0
		shift
	fi
fi

if [ -n "$1" -a "$1" = -h ] 2>/dev/null; then
	cat "$JSHOR/util/help_pages/dag_help.txt"
	echo ""
	exit 0
fi
# TODO: write a getopts

if [ $set_default = 'true' ]; then
	subnet=$default_subnet
else
	subnet=$(bash "$JSHOR/util/findSubnet.sh" $sn_index $iface)
fi
if [ -z "$subnet" ] 2>/dev/null; then
	echo -e "${RED}ERROR: could not find valid subnet.${NC}" >&2
	exit 1
fi

if [ "$ip" != "" -a $ip -ge 2 -a $ip -le 255 ] 2>/dev/null; then
	for i in ${dag_pages[@]}; do
		open -a "Google Chrome" $addons"http://$subnet.$ip/$i"
	done
else
	echo -e "${RED}ERROR: Please provide a valid IP.${NC}" >&2
fi
