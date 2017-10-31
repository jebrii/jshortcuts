#!/bin/bash

source "/Users/henryr/.bash_profile"

config_vars=$(bash "$JSHOR/resources/sanitize.sh" "$JSHOR/resources/.jshor_config")
eval "$config_vars"

# local variables
addons="-F "
filter=""
args_flag=""

if [ $# -eq 0 ]; then
  echo "No arguments provided. Opening JIRA homepage."
  open -a "$browser" $addons"https://$at_server.atlassian.net/"
  exit 0
fi

if [ ${1:0:1} != "-" ] ; then
  ticket=$1
  shift
fi

while getopts ":hp:t:cfb:Ns:ro" opt; do
  case $opt in
    h)
      cat "$JSHOR/resources/.help_pages/open_jira_help.txt"
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
    s) at_server="$OPTARG";;
    r) filter+="reported";;
    o) filter+="open";;
    :)
			echo -e "${RED}ERROR: Missing argument for $OPTARG.${NC}" >&2
			cat "$JSHOR/resources/.help_pages/open_jira_help.txt"
			exit 1
			;;
    \?)
      echo -e "${RED}Invalid option: -$OPTARG.${NC}" >&2
      exit 1
      ;;
  esac
done

case $filter in
  reported)
    echo "Opening Reported by Me filter"
    open $addons-a "$browser" $args_flag"https://$at_server.atlassian.net/secure/IssueNavigator.jspa?jql=reporter%20%3D%20currentUser%28%29%20order%20by%20created%20DESC"
    exit 0
    ;;
  open)
    echo "Opening My Open Issues filter"
    open $addons-a "$browser" $args_flag"https://$at_server.atlassian.net/secure/IssueNavigator.jspa?jql=assignee%20%3D%20currentUser%28%29%20AND%20resolution%20%3D%20Unresolved%20order%20by%20updated%20DESC"
    exit 0
    ;;
  "")
    ;;
  *)
    echo -e "${RED}ERROR: Please select only one filter flag.${NC}" >&2
    exit 1
    ;;
esac

if [ $ticket -gt 0 ] 2>/dev/null && [ $ticket -le 9999999 ]; then
  echo "Opening ticket $proj-$ticket with browser: $browser"
  open $addons-a "$browser" $args_flag"https://$at_server.atlassian.net/browse/$proj-$ticket"
else
  echo -e "${RED}ERROR: \"$ticket\" is not valid. Please enter a valid ticket number between 1 and 999999.${NC}" >&2
  exit 1
fi

exit 0
