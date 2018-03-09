#!/bin/bash

set -x

IP=`ifconfig  eth0|grep "inet"|awk -F ' ' 'NR==1{print $2}'`

cat <<EOF
bind $IP
dir /redis/rcluster/$port
port $port
cluster-enabled yes
daemonize yes
cluster-config-file nodes$port.conf 
pidfile /redis/rcluster/$port/redis-$port.pid
cluster-node-timeout 5000 
appendonly yes 
cluster-require-full-coverage no 
logfile "./$port.log"
EOF
