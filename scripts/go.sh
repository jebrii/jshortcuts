#! /bin/bash

source "/Users/henryr/.bash_profile"

config_vars=$(bash "$JSHOR/resources/sanitize.sh" "$JSHOR/resources/.jshor_config")
eval "$config_vars"

# local variables
ip=0

if [ -n $1 -a ${1:0:1} != "-" ] 2>/dev/null; then
	ip=$1
	shift
	if [ -n $1 -a ${1:0:1} != "-" ] 2>/dev/null ; then
		iface=$1
		snIndex=0
		shift
	fi
fi

while getopts ":ht:s:i:k:" opt; do
	if [ ${OPTARG:0:1} = "-" ] 2>/dev/null ; then
		echo -e "${RED}ERROR: Missing argument for $opt.${NC}" >&2
		cat "$JSHOR/resources/.help_pages/go_help.txt"
		exit 1
	fi
	case $opt in
		h)
			cat "$JSHOR/resources/.help_pages/go_help.txt"
			exit 0
			;;
		t) cmd="-t $OPTARG; bash -l";;
		s)
			if [ $OPTARG =~ '^[0-9]+$' ] 2>/dev/null; then
				snIndex=$OPTARG
			else
				echo -e "${RED}ERROR: Subnet index must be a positive integer.${NC}" >&2
				exit 1
			fi
			;;
		i)
			test_if=$(ifconfig $OPTARG 2>/dev/null | cut -f 1 | cut -c1-${#OPTARG})
			if [ "$test_if" = "$OPTARG" ]; then
				iface="$OPTARG "
				snIndex=0
			else
				echo -e "${RED}ERROR: Invalid iface provided.${NC}" >&2
				exit 1
			fi
			;;
		k) ssh_key_gw="$OPTARG";;
		:)
			echo -e "${RED}ERROR: Missing argument for $OPTARG.${NC}" >&2
			cat "$JSHOR/resources/.help_pages/go_help.txt"
			exit 1
			;;
		\?)
      echo -e "${RED}Invalid option -$OPTARG.${NC}" >&2
      exit 1
      ;;
	esac
done

subnet=$(bash "$JSHOR/resources/findSubnet.sh" $snIndex $iface)
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
	eval "ssh $user@$subnet.$ip -i $ssh_key_gw $cmd"
else
	echo "Please give me a valid ip!"
	exit 1
fi
