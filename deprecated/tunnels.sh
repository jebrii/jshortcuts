#! /bin/bash
# echo "Candi remote tunnel script by jebri"
fin=false
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo ""
echo "Welcome to the Candi remote tunnel interface!"
echo ""
echo "The current version of this program will require you to be running on Mac OS X with the Firefox browser installed."
echo ""
echo "Which type of tunnel are you trying to open?"
echo "Standard (s) - ssh tunnel into a remote gateway's command line interface."
echo "Diagnostics (d) - open diagnostics pages for a remote gateway in your browser."
echo "IP Device (ip) - open the interface for an IP device on a remote gateway's local network."
read -p "Desired tunnel type: " opt
while [ $fin = false ]; do
# Standard Option
	if [ $opt = "s" ]; then
		while [ $fin = false ]; do
			echo "Open tunnel using NOC interface and take note of port."
			read -p "Port #: " prt
			echo -n "Opening tunnel . " && sleep 0.5s && echo -n ". " && sleep 0.5s && echo -n ". " && sleep 0.5s && echo -n ". "
			echo ""
			bash $DIR/resources/term.sh "ssh root@10.37.37.116 -p $prt"
		if [ $? -eq 0 ]; then
			fin=true
		else
			echo "Tunnel failed to open. Try again or Ctrl+C to quit."
		fi
		done
# Diagnostics Option
	elif [ $opt = "d" ]; then
		while [ $fin = false ]; do
			echo "Open tunnel using NOC interface and take note of port."
			read -p "Port #: " prt
			read -p "Desired local port: " lhprt
			echo -n "Opening tunnel . " && sleep 0.5s && echo -n ". " && sleep 0.5s && echo -n ". " && sleep 0.5s && echo -n ". "
			echo ""
			bash $DIR/resources/term.sh "ssh root@10.37.37.116 -p $prt -L $lhprt:localhost:80"
			if [ $? -eq 0 ]; then
				echo -n "Opening diagnostics pages . " && sleep 0.5s && echo -n ". " && sleep 0.5s && echo -n ". " && sleep 0.5s && echo -n ". "
				echo ""
				open -a Firefox "http://localhost:$lhprt/Zuul/native.php"
				open -a Firefox "http://localhost:$lhprt/Zuul/zwave.php"
				open -a Firefox "http://localhost:$lhprt/Zuul/zuulServer.php?cmd=get_labels"
				open -a Firefox "http://localhost:$lhprt/Zuul/zuulServer.php?cmd=device_discovery"
				fin=true
			else
				echo "Tunnel failed to open. Try again or Ctrl+C to quit."
			fi
		done
# IP Device Option
	elif [ $opt = "ip" ]; then
		while [ $fin = false ]; do
			echo "Open tunnel using NOC interface and take note of port."
			read -p "Port #: " prt
			read -p "Desired local port: " lhprt
			read -p "Device IP: " dvip
			echo -n "Opening tunnel . " && sleep 0.5s && echo -n ". " && sleep 0.5s && echo -n ". " && sleep 0.5s && echo -n ". "
			echo ""
			bash $DIR/resources/term.sh "ssh root@10.37.37.116 -p $prt -L localhost:$lhprt:$dvip:80"
			if [ $? -eq 0 ]; then
				echo -n "Opening device home page . " && sleep 0.5s && echo -n ". " && sleep 0.5s && echo -n ". " && sleep 0.5s && echo -n ". "
				echo ""
				open -a Firefox "http://localhost:$lhprt"
				fin=true
			else
				echo "Tunnel failed to open. Try again or Ctrl+C to quit."
			fi
		done
# Bad Selection
	else
		read -p "Please enter either 's', 'd', or 'ip': " opt
	fi
done
echo ""
echo ""
echo "Thank you for using the Candi remote tunnel interface!"
echo ""
echo ""
