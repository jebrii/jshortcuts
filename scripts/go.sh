#! /bin/bash

# TODO: make it so we don't have to do this!!
source "/Users/henryr/.bash_profile"

# sanitize and source resource file(s)
config_vars=$(bash "$JSHOR/.resources/sanitize.sh" "$JSHOR/.resources/.jshor_config")
eval "$config_vars"

# local variables
ip=0

if [ -n $1 ]; then
	ip=$1
	shift
else
	echo "Please give me a valid ip!"
	exit 1
fi

while getopts ":ht:s:i:k:" opt; do
	case $opt in
		h)
			echo "help page"
			exit 0
			;;
		t)
			cmd="-t $OPTARG; bash -l"
			;;
		s)
			if [ $OPTARG =~ '^[0-9]+$' ]; then
				echo "true"
				snIndex=$OPTARG
			else
				echo -ne "${RED}ERROR: Subnet index must be integer 0 or greater${NC}"
				exit 1
			fi
			;;
		i)
			test_if=$(ifconfig $OPTARG 2>/dev/null | cut -f 1 | cut -c1-${#OPTARG})
			if [ "$test_if" = "$OPTARG" ]; then
				iface="$OPTARG "
				snIndex=0
			else
				echo -ne "${RED}ERROR: Invalid iface provided${NC}"
				exit 1
			fi
			;;
		k)
			if [ -e "$OPTARG" ]; then
				ssh_key_gw="$OPTARG"
			else
				echo -ne "${RED}ERROR: Invalide ssh key location provided${NC}"
				exit 1
			fi
			;;
		\?)
      # bad option given
      echo -e "${RED}Invalid option -$OPTARG ${NC}" <&2
      exit 1
      ;;
	esac
done

# get subnet once params are set
subnet=$(bash "$JSHOR/.resources/findSubnet.sh" $snIndex $iface)
if [ -z "$subnet" ]; then
	echo -ne "${RED}ERROR: could not find valid subnet${NC}"
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
