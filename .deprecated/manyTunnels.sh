#! /bin/bash

echo "STILL EXPERIENCING SOME DIFFICULTIES"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
read -p "Start local port sequence: " $lhprt
read -p "Network domain (first 3 of IP; \"X.X.X.\"): " $ntdmn
echo "eGauge IPs (last octet, no period, separated by spaces): "
read -a $egips
echo $egips
echo "Open tunnel using NOC interface and take note of port."
read -p "Tunnel port #: " $prt
$egnum = ${#egips[@]}
$foo = 1
echo "Opening tunnels"
while [ $foo -lte $egnum ]; do
	echo "EG #${egips[$foo]}:"
	bash $DIR/resources/term.sh "ssh root@10.37.37.116 -p $prt -L localhost:$lhprt:$ntdmn${egips[$foo]}:80"
	if [ $? -eq 0 ]; then
		echo -n "Opening device home page"
		open -a Firefox "http://localhost:$lhprt"
		$lhprt = $lhprt + 1
		$foo = $foo + 1
	else
		echo "Tunnel failed to open. Try again or Ctrl+C to quit."
	fi
done
