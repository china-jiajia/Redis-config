#!/bin/bash

#set -x


IP=`ifconfig  eth0|grep "inet"|awk -F ' ' 'NR==1{print $2}'`
TRIB=/usr/local/bin/redis-trib.rb
RCLI=/usr/local/bin/redis-cli


cluster-start(){
  $TRIB create --replicas 1 $IP:7000 $IP:7001 $IP:7002 $IP:7003 $IP:7004 $IP:7005
}

cluster-status(){
	$TRIB check $IP:7000
	sleep 1
	if [ $? = 0 ];then
		echo 
		$RCLI -c -h $IP -p 7000 cluster nodes
		sleep 1
		echo
		$RCLI -c -h $IP -p 7000 cluster info
	else
		echo "Redis-cluster Filed!"
		exit 1
	fi
}



case "$1" in
		cluster-start)
		cluster-start
		;;
		cluster-status)
		cluster-status
		;;
		*)
		echo "Usage: service `basename $0` {cluster-start|cluster-status}"
		exit 2
		;;
esac
