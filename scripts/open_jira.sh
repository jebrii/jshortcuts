#!/bin/bash

source "/Users/${USER}/.bash_profile"

config_vars=$(bash "$JSHOR/src/sanitize.sh" "$JSHOR/src/.jshor_config")
eval "$config_vars"

# local variables
addons="-F "
filter=""
args_flag=""

more_tickets=0;

if [ $# -eq 0 ]; then
  echo "No arguments provided. Opening JIRA homepage."
  open -a "$browser" $addons"https://$jira_server/"
  exit 0
fi

if [ "${1:0:1}" != "-" ] ; then
  ticket="$1"
  shift
  if [ -n $1 ] && [ "${1:0:1}" != "-" ] ; then
    more_tickets=1
    tickets[0]=$ticket;
    count=1
    while [ -n "$1" ] && [ "${1:0:1}" != "-" ] ; do
      tickets[$count]="$1"
      count=$((count + 1))
      if [ -n "$2" ] ; then
        shift
      else
        break
      fi
      if [ $count -gt 50 ] ; then
        break
      fi
    done
  fi
fi

while getopts ":hp:t:cfb:Ns:Bro" opt; do
  case $opt in
    h)
      cat "$JSHOR/src/help_pages/open_jira_help.txt"
      exit 0
      ;;
    p) proj=$OPTARG;;
    t) ticket=$OPTARG;;
    c) browser="Google Chrome";;
    f) browser="Firefox";;
    b) browser=$OPTARG;;
    N)
      # addons+="-n "
      # args_flag="--args "
      echo -e "${WHITE}The new tab feature is currently deprecated.${NC}"
      ;;
    s) jira_server="$OPTARG";;
    B) filter+="board";;
    r) filter+="reported";;
    o) filter+="open";;
    :)
			echo -e "${RED}ERROR: Missing argument for $OPTARG.${NC}" >&2
			cat "$JSHOR/src/help_pages/open_jira_help.txt"
			exit 1
			;;
    \?)
      echo -e "${RED}Invalid option: -$OPTARG.${NC}" >&2
      exit 1
      ;;
  esac
done

case $filter in
  board)
    echo "Opening Rapid Board"
    open $addons-a "$browser" $args_flag"https://$jira_server/secure/RapidBoard.jspa"
    exit 0
    ;;
  reported)
    echo "Opening Reported by Me filter"
    open $addons-a "$browser" $args_flag"https://$jira_server/secure/IssueNavigator.jspa?jql=reporter%20%3D%20currentUser%28%29%20order%20by%20created%20DESC"
    exit 0
    ;;
  open)
    echo "Opening My Open Issues filter"
    open $addons-a "$browser" $args_flag"https://$jira_server/secure/IssueNavigator.jspa?jql=assignee%20%3D%20currentUser%28%29%20AND%20resolution%20%3D%20Unresolved%20order%20by%20updated%20DESC"
    exit 0
    ;;
  "")
    ;;
  *)
    echo -e "${RED}ERROR: Please select only one filter flag.${NC}" >&2
    exit 1
    ;;
esac

if [ $more_tickets -eq 0 ] ; then
  if [ $ticket -gt 0 ] 2>/dev/null && [ $ticket -le 9999999 ]; then
    echo "Opening ticket $proj-$ticket with browser: $browser"
    open $addons-a "$browser" $args_flag"https://$jira_server/browse/$proj-$ticket"
  else
    echo -e "${RED}ERROR: \"$ticket\" is not valid. Please enter a valid ticket number between 1 and 999999.${NC}" >&2
    exit 1
  fi
elif [ $more_tickets -eq 1 ] ; then
  for i in "${tickets[@]}" ; do
    ticket="$i"
    if [ $ticket -gt 0 ] 2>/dev/null && [ $ticket -le 9999999 ]; then
      echo "Opening ticket $proj-$ticket with browser: $browser"
      open $addons-a "$browser" $args_flag"https://$jira_server/browse/$proj-$ticket"
    else
      echo -e "${RED}ERROR: \"$ticket\" is not valid. Please enter a valid ticket number between 1 and 999999.${NC}" >&2
    fi
  done
else
  echo "whoops!"
  exit 1
fi

exit 0
