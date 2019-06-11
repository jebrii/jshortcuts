#! /bin/bash

source "/Users/${USER}/.bash_profile"

config_vars=$(bash "$JSHOR/util/sanitize.sh" "$JSHOR/util/.jshor_config")
eval "$config_vars"

# local variables
remove=false

if [ -n "$1" -a "${1:0:1}" != "-" ]; then
	al_ip="$1"
	shift
	if [ -n "$1" -a "${1:0:1}" != "-" ]; then
		al_iface="$1"
		shift
	fi
fi

while getopts ":i:a:n:rlh" opt; do
	if [ ${OPTARG:0:1} = "-" ] 2>/dev/null ; then
		echo -e "${RED}ERROR: Missing argument for $opt.${NC}" >&2
		cat "$JSHOR/util/help_pages/alias_adder_help.txt"
		exit 1
	fi
	case $opt in
    h)
      cat "$JSHOR/util/help_pages/alias_adder_help.txt"
      exit 0
      ;;
    i) al_iface="$OPTARG";;
    a) al_ip="$OPTARG";;
    n) al_nm="$OPTARG";;
    r) remove=true;;
		l)
			echo -n "Aliases currently set up with this tool:"
			# Make this compare /tmp/aliases-list.txt to ifconfig?
			cat "/tmp/aliases-list.txt"
			exit 0
			;;
		:)
			echo -e "${RED}ERROR: Missing argument for $OPTARG.${NC}" >&2
			cat "$JSHOR/util/help_pages/alias_adder_help.txt"
			exit 1
			;;
    \?)
      echo -e "${RED}ERROR: Invalid option -$OPTARG.${NC}" >&2
      exit 1
      ;;
  esac
done

if $remove; then
  sudo ifconfig $al_iface -alias $al_ip $al_nm
  if [ $? -eq 0 ]; then
		sed -e "s/$al_iface $al_ip $al_nm//g" -i .backup "/tmp/aliases-list.txt"
    echo "Alias successfully removed from $al_iface with IP of $al_ip and netmask of $al_nm"
  else
    echo -e "${RED}ERROR: Alias remove failed.${NC}"
    exit 1
  fi
else
  sudo ifconfig $al_iface alias $al_ip $al_nm
  if [ $? -eq 0 ]; then
		# if [ ! -f "/tmp/aliases-list.txt"]; then
		# 	touch "/tmp/aliases-list.txt"
		# fi
		echo "$al_iface $al_ip $al_nm" >> "/tmp/aliases-list.txt"
		echo "Alias successfully added to $al_iface with IP of $al_ip and netmask of $al_nm"
  else
    echo -e "${RED}ERROR: Alias add failed.${NC}"
    exit 1
  fi
fi
exit 0
