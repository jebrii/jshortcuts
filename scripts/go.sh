#! /bin/bash

# TODO: make it so we don't have to do this!!
source "/Users/henryr/.bash_profile"

# sanitize and source resource file(s)
config_vars=$(bash "$JSHOR/.resources/sanitize.sh" "$JSHOR/.resources/.jshor_config")
eval "$config_vars"

# local variables
subnet=$(bash "$JSHOR/.resources/findSubnet.sh" $snIndex $iface)
ip=0

if [ -n $1 ]; then
	ip=$1
	shift
else
	echo "Please give me a valid ip!"
	exit 1
fi

while getopts ":ht:i:" opt; do
	case $opt in
		h)
			echo "help page"
			exit 0
			;;
		t)
			cmd="-t $OPTARG; bash -l"
			;;
		i)
			if [ $OPTARG =~ '^[0-9]+$' ]; then
				echo "true"
				snIndex=$OPTARG
			else
				echo -ne $RED
				echo "ERROR: Subnet index must be integer 0 or greater"
				echo -ne $NC
				exit 1
			fi
			;;
	esac
done

if [ $ip -ge 2 -a $ip -le 255 ] 2>/dev/null; then
	while true; do
		ping -c 1 $subnet.$ip
		if [ $? -eq 0 ]; then
			break
		else
			sleep 30
		fi
	done
	eval "ssh $user@$subnet.$ip -i $key $cmd"
else
	echo "Please give me a valid ip!"
	exit 1
fi
