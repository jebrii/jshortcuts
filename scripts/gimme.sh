# /bin/bash

#! /bin/bash

source "/Users/${USER}/.bash_profile"

config_vars=$(bash "$JSHOR/src/sanitize.sh" "$JSHOR/src/.jshor_config")
eval "$config_vars"

# local variables
ip=0
reverse="false"
set_default='false'

if [ -n "$1" -a "${1:0:1}" != "-" ]; then
	ip="$1"
  shift
  if [ -n "$1" -a "${1:0:1}" != "-" ]; then
    file="$1"
    shift
  fi
fi

while getopts ":ht:s:i:kf:d:rD" opt; do
	case $opt in
		h)
		cat "$JSHOR/src/help_pages/gimme_help.txt"
		echo ""
		exit 0
			;;
		t) cmd="-t $OPTARG; bash -l";;
		s)
			if [ $OPTARG =~ '^[0-9]+$' ]; then
				echo "true"
				snIndex=$OPTARG
			else
				echo -e "${RED}ERROR: Subnet index must be integer 0 or greater.${NC}" >&2
				exit 1
			fi
			;;
		i)
			test_iface=$(ifconfig $OPTARG 2>/dev/null | cut -f 1 | cut -c1-${#OPTARG})
			if [ "$test_iface" = "$OPTARG" ]; then
				iface="$OPTARG "
				snIndex=0
			else
				echo -e "${RED}ERROR: Invalid iface provided.${NC}" >&2
				exit 1
			fi
			;;
		k) ssh_key_gw="$OPTARG";;
    f) file="$OPTARG";;
		d) dest="$OPTARG";;
    r) reverse="true";;
		D) set_default='true';;
		:)
			echo -e "${RED}ERROR: Missing argument for $OPTARG.${NC}" >&2
			cat "$JSHOR/src/help_pages/gimme_help.txt"
			exit 1
			;;
		\?)
      echo -e "${RED}Invalid option -$OPTARG ${NC}" <&2
      exit 1
      ;;
	esac
done

if [ $set_default = 'true' ]; then
	subnet=$default_subnet
else
	subnet=$(bash "$JSHOR/src/findSubnet.sh" $snIndex $iface)
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
  if [ "$file" == "" ]; then
		echo "Enter the path to the file you want: "
		read file
	fi
  if [ $reverse == "true" ]; then
		echo "reverse, reverse!!"
    scp -i $ssh_key_gw $file "$user@$subnet.$ip:$dest"
  else
     scp -i $ssh_key_gw "$user@$subnet.$ip:$file" $dest
   fi
else
	echo "Please gimme a valid ip!" >&2
	exit 1
fi
