#! /bin/bash
echo "The current version of this program will require you to be running on Mac OS X with the Firefox browser and jebri shortcuts pack installed."

# =====variables======
fin=false
count=1
# string to be added to, then run as command at end
tunnelCmd="ssh root@10.37.37.116 -i ~/.ssh/candi"
# string to append to tunnelCmd and lhprt
portTail=""
# String to open the firefox windows for these meters
FFOpen=""
# String to curl the meters requesting data
dataReq=""
# Ask user what localhost port to start at, in a series
read -p "Desired local port start: " lhprt
# Ask for desired date range
read -p "Desired start date/time (epoch time): " dateStart
echo -n "Will start on "
date -r $dateStart
read -p "Desired end date/time (epoch time): " dateEnd
echo -n "Will end on "
date -r $dateEnd
# Ask for interval
read -p "Desired minute interval: " minIntHoldr
minInt=$(expr $minIntHoldr - 1)

# =====user input=====
# Ask user for all the IPs of devices they want to port to and make strings
while [ $fin != "done" ]; do
	read -p "Device $count name: " dvName
	read -p "Device $count IP: " dvip
	portTail="$portTail -L localhost:$lhprt:$dvip:80"
	FFOpen="${FFOpen}open -a Firefox \"http://localhost:$lhprt\" && "
	datareq="${datareq}echo \"Retrieving data for $dvName\" && curl \"http://localhost:$lhprt/cgi-bin/egauge-show?c&m&s=4&f=$dateEnd&t=$dateStart\" > ${dvName}.csv && "
	echo ""
	read -p "Enter = more, [any text] = quit
" finL
	if [ ${#finL} -ne 0 ]; then
		fin="done"
	fi
	count=$(expr $count + 1)
	lhprt=$(expr $lhprt + 1)
done

FFOpen="$FFOpen""echo done"
datareq="$datareq""echo done"

# =====get tunnel port, build cmd string=====
read -p 'Port #: ' prt
tunnelCmd="$tunnelCmd -p ${prt}$portTail"
# ++debug++
echo ""
echo "This is the tunnel cmd:
$tunnelCmd"
echo ""
# ++end debug++
# =====run scripts======
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
bash $DIR/resources/term.sh "$tunnelCmd"
echo "Tunnel opening. Confirm success, then hit enter when ready..."
read -p "" foo
bash $DIR/resources/term.sh "$FFOpen"
echo ""
echo "Browser windows opening to all eGauges. Confirm that there is no password set, then hit enter when ready..."
read -p "" shooBop
echo ""
echo "This is the data request:
$datareq"
echo ""
echo "Hit enter to begin data request process..."
read -p "" bar
eval $datareq
