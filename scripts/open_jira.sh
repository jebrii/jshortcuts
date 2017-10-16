#!/bin/bash

# TODO: make it so we don't have to do this!!
source "/Users/henryr/.bash_profile"

# sanitize and source resource file(s)
config_vars=$(bash "$JSHOR/resources/sanitize.sh" "$JSHOR/resources/.jshor_config")
eval "$config_vars"

# local variables
addons=""
filter=""

if [ $# -eq 0 ]; then # test for arguments at all
  echo "ERROR: Please specify parameters as follows." >&2
  echo "(Henry, please add parameter options)."
  exit 1
else
  if [ ${1:0:1} != "-" ] ; then # set ticket and shift if first argument is not an option
    ticket=$1
    shift
  fi
  while getopts ":hp:t:cfb:Ns:ro" opt; do
    case $opt in
      h)
        cat "$JSHOR/resources/.help_pages/open_jira_help.txt"
        # When help is triggered, exit ignoring other commands
        exit 0
	      ;;
      p)
        # check for empty argument
        if [ $OPTARG = "" ] || [ ${OPTARG:0:1} = "-" ] ; then
          echo "ERROR: No argument given for option -p" >&2
          exit 1
        else
          # set the project
          proj=$OPTARG
#D          echo "DEBUG: project set to $OPTARG"
        fi
        ;;
      t)
        # check for empty argument
        if [ $OPTARG = "" ] || [ ${OPTARG:0:1} = "-" ] ; then
          echo "ERROR: No argument given for option -t" >&2
          exit 1
        else
          # set ticket
          ticket=$OPTARG
#D          echo "DEBUG: ticket set to $OPTARG"
        fi
        ;;
      c)
        # set browser to Chrome
        browser="Google Chrome"
        ;;
      f)
        # set browser to Firefox
        browser="Firefox"
        ;;
      b)
        # check for empty argument
        if [ $OPTARG = "" ] || [ ${OPTARG:0:1} = "-" ]; then
          echo "ERROR: No argument given for option -b" >&2
          exit 1
        else
          # set browser
          browser=$OPTARG
#D          echo "DEBUG: browser set to $OPTARG"
        fi
        ;;
      N)
#D        echo "DEBUG: here"
        # add -n to addons
        addons="-n "
        ;;
      s)
        if [ -e "$OPTARG" ]; then
          at_server="$OPTARG"
        else
          echo -ne "${RED}ERROR: Invalide atlassian server provided${NC}"
          exit 1
        fi
        ;;
      r)
        filter+="reported"
        ;;
      o)
        filter+="open"
        ;;
      \?)
        # bad option given
        echo "Invalid option -$OPTARG" <&2
        exit 1
        ;;
    esac
  done

  case $filter in
    reported)
      echo "Opening Reported by Me filter"
      open -a "$browser" $addons"https://$at_server.atlassian.net/secure/IssueNavigator.jspa?jql=reporter%20%3D%20currentUser%28%29%20order%20by%20created%20DESC"
      exit 0
      ;;
    open)
      echo "Opening My Open Issues filter"
      open -a "$browser" $addons"https://$at_server.atlassian.net/secure/IssueNavigator.jspa?jql=assignee%20%3D%20currentUser%28%29%20AND%20resolution%20%3D%20Unresolved%20order%20by%20updated%20DESC"
      exit 0
      ;;
    "")
      echo "check check"
      ;;
    *)
      echo "ERROR: Please select only one filter flag" >&2
      exit 1
      ;;
  esac

  if [ $ticket -gt 0 ] && [ $ticket -le 999999 ]; then # check if ticket is a number
    # all options are set, execute the command
    echo "Opening ticket $proj-$ticket with browser: $browser"
    open -a "$browser" $addons"https://$at_server.atlassian.net/browse/$proj-$ticket"
  else
    echo "ERROR: \"$ticket\" is not valid. Please enter a valid ticket number between 1 and 999999"
    exit 1
  fi
fi
exit 0
