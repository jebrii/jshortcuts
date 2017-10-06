#! /bin/bash
echo "Welcome to the Candi Remote Gateway Data Dump interface!"
echo ""

echo "STILL EXPERIENCING SOME DIFFICULTIES"
echo "param1 = $1"
echo "param2 = $2"
echo "param3 = $3"

if [ "$#" -eq 0 ]; then
	read -p "Tunnel port? " prt
	read -p "Site name? " stnm
	read -p "Dump tag/number? " dmpnum
elif [ "$#" -eq 3 ]; then
	prt="$1"
	stnm="$2"
	dmpnum="$3"
else
	echo "Parameter error."
	echo "Please provide either no parameters, or 3 parameters, in the following format:"
	echo "jsonTablesCopy.sh [Tunnel Port] [Site Name] [Dump tag]"
	echo ""
	read -p "Tunnel port? " prt
        read -p "Site name? " stnm
        read -p "Dump tag/number? " dmpnum
fi

if [ ! -d "DataDump$dmpnum" ]; then
	echo "Creating Directory: DataDump$dmpnum"
	mkdir "DataDump$dmpnum"
	echo "Creating Directory: DataDump$dmpnum/$stnm"
	mkdir "DataDump$dmpnum/$stnm"
elif [ ! -d "DataDump$dmpnum/$stnm" ]; then
	echo "Creating Directory: DataDump$dmpnum/$stnm"
	mkdir "DataDump$dmpnum/$stnm"
fi
echo "Running command: \"scp -P $prt root@10.37.37.116:/var/lib/candi/Candi_store/json/* ./DataDump$dmpnum/$stnm/\""
scp -P $prt root@10.37.37.116:/var/lib/candi/Candi_store/json/* ./DataDump$dmpnum/$stnm/
if [ $? -eq 0 ]; then
	echo "done"
else
	echo "ERROR: unable to copy file. Try again."
fi
