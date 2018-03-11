#!/bin/bash
MASTER_IP=$6 				
LOCAL_IP=`ifconfig bond0|awk -F ":" 'NR==2{print $2}'|awk '{print $1}'` 	
VIP='10.96.28.140'
NETMASK='24'
INTERFACE='bond0'

if [[ "${MASTER_IP}" == "${LOCAL_IP}" ]];then
	/sbin/ip addr add ${VIP}/${NETMASK} dev ${INTERFACE}          
	/sbin/arping -q -c 3 -A ${VIP} -I ${INTERFACE}
	exit 0 
else
	/sbin/ip addr del ${VIP}/${NETMASK} dev ${INTERFACE}		 
	exit 0
fi

exit 1

