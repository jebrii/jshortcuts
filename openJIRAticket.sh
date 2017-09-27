#!/bin/bash

proj="CANDI"
browser="Google Chrome"
addons=""

if [ $# -eq 0 ]; then # test for arguments at all
  echo "ERROR: Please specify parameters as follows."
  echo "(Henry, please add parameter options)."
else
  if [ ${1:0:1} != "-" ] ; then # set ticket and shift if first argument is not an option
    ticket=$1
    shift
  fi
  while getopts ":hp:t:cfb:N" opt; do
    case $opt in
      h)
        echo "This is the help script for openJIRAticket.sh by jebri...."
        echo "..."
        echo "...or rather it will be"
        echo ""
        echo "-h for help"
        echo "-p to set project (e.g. \"-p CANDI\")"
        echo "-c to open with Google Chrome"
        echo "-f to open with Firefox"
        echo "-b to set the browser manually (enter text string of browser application on your machine)"
        echo "-t sets the ticket"
        echo "-N opens the ticket in a new window"
        echo ""
        echo "This script can be run without any options and requires only the argument of the ticket desired."
        echo "If only the ticket number is provided, it will default to project CANDI and browser Google Chrome."
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
      \?)
        # bad option given
        echo "Invalid option -$OPTARG" <&2
        exit 1
        ;;
    esac
  done
  if [ $ticket -gt 0 ] && [ $ticket -le 999999 ]; then # check if ticket is a number
    # all options are set, execute the command
    echo "Opening ticket $proj-$ticket with browser: $browser"
#D    echo "DEBUG: this is the command..."
#D    echo "open -a \"$browser\" \"https://candicontrols.atlassian.net/browse/$proj-$ticket\""
    open -a "$browser" $addons"https://candicontrols.atlassian.net/browse/$proj-$ticket"
  else
    echo "ERROR: \"$ticket\" is not valid. Please enter a valid ticket number between 1 and 999999"
    exit 1
  fi
fi
exit 0
