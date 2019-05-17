#!/bin/bash

source "/Users/${USER}/.bash_profile"

config_vars=$(bash "$JSHOR/util/sanitize.sh" "$JSHOR/util/.jshor_config")
eval "$config_vars"

# local variables
addons="-F "

if [ "${1:0:1}" != "-" ] ; then
  query="$1"
  shift
fi

while getopts ":hp:t:cfb:Ns:ro" opt; do
  case $opt in
    h)
      cat "$JSHOR/util/help_pages/open_conf_help.txt"
      exit 0
      ;;
    c) browser="Google Chrome";;
    f) browser="Firefox";;
    b) browser=$OPTARG;;
    N)
      # addons+="-n "
      # args_flag="--args "
      echo -e "${WHITE}The new tab feature is currently deprecated.${NC}"
      ;;
    s) conf_server="$OPTARG";;
    :)
			echo -e "${RED}ERROR: Missing argument for $OPTARG.${NC}" >&2
			cat "$JSHOR/util/help_pages/open_jira_help.txt"
			exit 1
			;;
    \?)
      echo -e "${RED}Invalid option: -$OPTARG.${NC}" >&2
      exit 1
      ;;
  esac
done

if [ -n "$query" ]; then
  echo "Opening confluence with browser: $browser and search query: $query"
  open $addons-a "$browser" $args_flag"https://$conf_server/dosearchsite.action?queryString=$query"
  exit 0
else
  echo "Opening confluence homepage with browser: $browser"
  open $addons-a "$browser" $args_flag"https://$conf_server"
  exit 0
fi

exit 0
