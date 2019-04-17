#! /bin/bash

  LocalPort=$1
  SSHZuulPort_Gateway=$2
  eGaugeIP=$3
    if [ "" != "$1" ];then
		ssh root@10.37.37.116 -p $2 -L localhost:$1:$3:80
	    else
		echo "ERROR: Parameters not provided. Please provide parameters as listed below"
		echo "setupRemoteWebLink.sh {LocalPort} {SSHZuulPort_Gateway} {eGaugeIP}"
    fi
