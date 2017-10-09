#! /bin/bash

source "/Users/henryr/.bash_profile"

# sanitize and source resourve file(s)
config_vars=$(bash "$JSHOR/resources/sanitize.sh" "$JSHOR/resources/.jshor_config")
eval "$config_vars"

# local variables
remove=false

if [ -n $1 ]; then
	if [ ${1:0:1} != "-" ]; then
		al_ip=$1
		shift
		if [ -n $1 ]; then
			if [ ${1:0:1} != "-" ]; then
				iface=$1
				shift
			fi
		fi
	fi
fi

while getopts ":i:a:n:rh" opt; do
#D    echo "DEBUG: entered while loop"
  case $opt in
    h)
      cat "$JSHOR/resources/.help_pages/alias_adder_help.txt"
      # When help is triggered, exit ignoring other commands
      exit 0
      ;;
    i)
      # check for empty argument
      if [ $OPTARG = "" ] || [ ${OPTARG:0:1} = "-" ] ; then
        echo -e "${RED}ERROR: No argument given for option -i${NC}" >&2
        exit 1
      else
        # Set inteface to argument
        iface="$OPTARG"
      fi
      ;;
    a)
      # check for empty argument
      if [ $OPTARG = "" ] || [ ${OPTARG:0:1} = "-" ] ; then
        echo -e "${RED}ERROR: No argument given for option -a${NC}" >&2
        exit 1
      else
        # set alias ip to argument
        al_ip="$OPTARG"
      fi
      ;;
    n)
      # check for empty argument
      if [ $OPTARG = "" ] || [ ${OPTARG:0:1} = "-" ] ; then
        echo -e "${RED}ERROR: No argument given for option -n${NC}" >&2
        exit 1
      else
        # set netmask to argument
        al_nm="$OPTARG"
      fi
      ;;
    r)
      # Add hyphen before alias to make it so alias is removed
      remove=true
      ;;
    \?)
      # bad option given
      echo -e "${RED} Invalid option -$OPTARG ${NC}" <&2
      exit 1
      ;;
  esac
done

# arguments parsed - run command
if $remove; then
  ifconfig $iface -alias $al_ip $al_nm
  if [ $? -eq 0 ]; then
    echo "Alias successfully removed from $iface with IP of $al_ip and netmask of $al_nm"
  else
    echo -e "${RED}Alias remove failed${NC}"
    exit 1
  fi
else
  ifconfig $iface alias $al_ip $al_nm
  if [ $? -eq 0 ]; then
    echo "Alias successfully added to $iface with IP of $al_ip and netmask of $al_nm"
  else
    echo -e "${RED}Alias add failed${NC}"
    exit 1
  fi
fi
exit 0
