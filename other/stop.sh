#!/bin/bash

set -x

IP=`ifconfig  eth0|grep "inet"|awk -F ' ' 'NR==1{print $2}'`

for ((i=0; i<6; ++i))
do
    echo 700$i
    /usr/local/bin/redis-cli $IP -p 700$i shutdown
       
done
