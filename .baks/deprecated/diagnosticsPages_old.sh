#!/bin/bash
# echo "Candi diagnostics pages script by jebri"
 GatewayIP=$1
 if [ "" != "$1" ]; then
	if [ $1 -ge 2 -a $1 -le 255 ]; then
		open -a Firefox 'http://10.38.0.'$1'/Zuul/zuulServer.php?cmd=login&user_login=henryr&user_password='
		echo "Opening diagnostics pages...."
		open -a Firefox 'http://10.38.0.'$1'/Zuul/native.php'
		open -a Firefox 'http://10.38.0.'$1'/Zuul/zwave.php'
		open -a Firefox 'http://10.38.0.'$1'/Zuul/zuulServer.php?cmd=get_labels'
		open -a Firefox 'http://10.38.0.'$1'/Zuul/zuulServer.php?cmd=discovery'
		echo "Pages ready for diagnostics on gateway at 10.38.0."$1
	else
		echo "ERROR: Value provided is not a valid number."
	fi
else
	echo "ERROR: Gateway IP not provided. Please provide the last octet of the gateway's local IP."
 fi
