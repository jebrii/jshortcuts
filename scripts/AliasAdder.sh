#! /bin/bash

# sanitize and source resourve file(s)
config_file="$JSHOR/.resources/.jshor_config"
config_file_secure="$JSHOR/.resources/.jshor_config_secure"
egrep '^#|^[^ ]*=[^;&]*' "$config_file" > "$config_file_secure"

source $config_file_secure

# local variables
remove=false

if [ ${1:0:1} != "-" ] ; then # set aliasIP and shift if first argument is not an option
  aliasIP=$1
  shift
fi

while getopts ":i:a:n:rh" opt; do
#D    echo "DEBUG: entered while loop"
  case $opt in
    h)
      echo -ne $CYAN
      echo ''
      echo 'aliasAdd: Used to quickly set an alias to a network interface.'
      echo ''
      echo 'Usage: aliasAdd [aliasIP] [-i:a:n:rh] [parameters]'
      echo ''
      echo "-h for help"
      echo "-i to set interface (e.g. \"$interface\")"
      echo "-a to set alias IP (e.g. \"$aliasIP\")"
      echo "-n to set netmask (e.g. \"$netmask\")"
      echo "-r to specify remove of alias (rather than add)"
      echo -ne $NC
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
        interface="$OPTARG"
      fi
      ;;
    a)
      # check for empty argument
      if [ $OPTARG = "" ] || [ ${OPTARG:0:1} = "-" ] ; then
        echo -e "${RED}ERROR: No argument given for option -a${NC}" >&2
        exit 1
      else
        # set alias ip to argument
        aliasIP="$OPTARG"
      fi
      ;;
    n)
      # check for empty argument
      if [ $OPTARG = "" ] || [ ${OPTARG:0:1} = "-" ] ; then
        echo -e "${RED}ERROR: No argument given for option -n${NC}" >&2
        exit 1
      else
        # set netmask to argument
        netmask="$OPTARG"
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
  ifconfig $interface -alias $aliasIP $netmask
  if [ $? -eq 0 ]; then
    echo "Alias successfully removed from $interface with IP of $aliasIP and netmask of $netmask"
  else
    echo -e "${RED}Alias remove failed${NC}"
    exit 1
  fi
else
  ifconfig $interface alias $aliasIP $netmask
  if [ $? -eq 0 ]; then
    echo "Alias successfully added to $interface with IP of $aliasIP and netmask of $netmask"
  else
    echo -e "${RED}Alias add failed${NC}"
    exit 1
  fi
fi
exit 0
