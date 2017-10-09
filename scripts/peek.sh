#! /bin/bash

# preset values
# iface="en0 "
ip="$1"
key="/Users/henryr/.ssh/keys/candi4k"
user="root"
snIndex="1" # skip localhost

# ssh in with a command
if [ $# -eq 2 ] ; then
	cmd='-t "'$2'; bash -l"'
	echo "cmd = \"$cmd\""
else
	cmd=""
fi

# TODO: write a getopts that changes above values

# assign variables after options are parsed
allSubnets=($(ifconfig $iface| grep "inet " | cut -d " " -f 2 | cut -d . -f 1-3))
while true; do
	subnet=${allSubnets[$snIndex]}

	octets=()
	for i in 1 2 3; do
		octets+=($(echo $subnet | cut -d . -f $i))
#		echo " array is: ${octets[@]} ...after iteration $i"
	done
	if [ -n ${octets[0]} ]; then
		if [ -n ${octets[1]} ]; then
			if [ -n ${octets[2]} ]; then
#				echo "good subnet: $subnet"
				break
			fi
		fi
	fi
	let snIndex++
	if [ $snIndex -gt ${#allSubnets[@]} ]; then
		echo "ERROR: Could not find valid subnet."
		exit 1
	fi
done

# echo "subnets:"
# echo ${allSubnets[@]}
# echo "chosen subnet: $subnet"

if [ $ip -ge 2 -a $ip -le 255 ]; then
	while true; do
		ping -c 1 $subnet.$ip
		if [ $? -eq 0 ]; then
			break
		else
			sleep 30
		fi
	done
	open -a "Google Chrome" "http://$subnet.$ip"
else
	echo "ERROR: Value provided is not a valid number."
fi
