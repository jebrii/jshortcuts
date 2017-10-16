#! /bin/bash

# TODO: make it so we don't have to do this!!
source "/Users/henryr/.bash_profile"

# sanitize and source resource file(s)
config_vars=$(bash "$JSHOR/resources/sanitize.sh" "$JSHOR/resources/.jshor_config")
eval "$config_vars"

# local variables

while getopts ":hs:i:t:k:" opt; do
	case $opt in
		h)
		cat "$JSHOR/resources/.help_pages/go_help.txt"
		exit 0
		;;
		s)
			if [ $OPTARG =~ '^[0-9]+$' ] 2>/dev/null; then
				snIndex=$OPTARG
			else
				echo -e "${RED}ERROR: Subnet index must be integer 0 or greater${NC}" <&2
				exit 1
			fi
			;;
		i)
			test_if=$(ifconfig $OPTARG 2>/dev/null | cut -f 1 | cut -c1-${#OPTARG}) <&2
			if [ "$test_if" = "$OPTARG" ]; then
				iface="$OPTARG "
				snIndex=0
			else
				echo -e "${RED}ERROR: Invalid iface provided${NC}" <&2
				exit 1
			fi
			;;
		t)	cmd="-t $OPTARG; bash -l";;
		k)	ssh_key_gw="$OPTARG";;
		\?)
      echo -e "${RED}Invalid option -$OPTARG ${NC}" <&2
      exit 1
      ;;
	esac
done
shift $(expr $OPTIND - 1)

if [ -n $1 ]; then
	ip=$1
	if [ -n $2 ]; then
	iface=$2
	fi
fi

# get subnet once params are set
subnet=$(bash "$JSHOR/resources/findSubnet.sh" $snIndex $iface)
if [ -z "$subnet" ]; then
	echo -e "${RED}ERROR: could not find valid subnet${NC}" <&2
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
