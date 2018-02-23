#!/bin/bash

set -x

IP=`ifconfig  eth0|grep "inet"|awk -F ' ' 'NR==1{print $2}'`

for ((i=0; i<8; ++i))
do
    echo 700$i
    /usr/bin/redis-server /redis/rcluster/700$i/700$i.conf
       
done
