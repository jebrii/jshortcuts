#! /bin/bash

# Take inputs (TODO: verify)
sn_index=$1
iface=$2

# assign variables after options are parsed
allSubnets=($(ifconfig $iface| grep "inet " | cut -d " " -f 2 | cut -d . -f 1-3))
while true; do
	subnet=${allSubnets[$sn_index]}
	octets=()
	for i in 1 2 3; do
		octets+=($(echo $subnet | cut -d . -f $i))
	done
	if [ -n ${octets[0]} -a -n ${octets[1]} -a -n ${octets[2]} ]; then
		break
	fi
	let sn_index++
	if [ $sn_index -gt ${#allSubnets[@]} ]; then
		echo "${RED}ERROR: Could not find valid subnet.${NC}" >&2
		exit 1
	fi
done

echo $subnet
