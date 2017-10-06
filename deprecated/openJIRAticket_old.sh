#!/bin/bash

if [ $# -eq 0 ]; then
	echo "ERROR: Ticket number not provided."
else
	TicketNum=$1
	echo "Opening ticket "$1
	open -a "Google Chrome" 'https://candicontrols.atlassian.net/browse/CANDI-'$1
fi
