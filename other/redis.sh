#!/bin/sh
#
#chkconfig: 2345 80 90
# Simple Redis init.d script conceived to work on Linux systems
# as it does use of the /proc filesystem.

source /etc/profile
#set -x

IP=`ifconfig  eth0|grep "inet"|awk -F ' ' 'NR==1{print $2}'`
EXEC=/usr/local/bin/redis-server
CLIEXEC=/usr/local/bin/redis-cli
CONF=/redis/rcluster



start(){
for ((i=0; i<8; ++i))
do
    echo 700$i
    sleep 1
    if [ -f /redis/rcluster/700$i/redis-700$i.pid ];then
    	echo "$PIDFILE exists, process is already running or crashed"
    else
    	echo "Starting Redis server..."
    	$EXEC  $CONF/700$i/700$i.conf
    fi   
done
}

stop(){
for ((i=0; i<8; ++i))
do
    echo 700$i
    sleep 1
    if [ ! -f /redis/rcluster/700$i/redis-700$i.pid ];then
    	echo "$PIDFILE does not exist, process is not running"
    else
    	echo "Stopping ..."
    	$CLIEXEC -h $IP -p 700$i shutdown
    fi
done
}

status(){
for ((i=0; i<8; ++i))
do
    echo 700$i
    sleep 1
  	if [ -f /redis/rcluster/700$i/redis-700$i.pid ] && netstat -tnl | grep 700$i &>/dev/null
	then
		echo "`basename $0` is running,PID is `cat /redis/rcluster/700$i/redis-700$i.pid`"
	else
		echo "`basename $0` is stopped."
	fi      
done
}

restart() {
	stop
	start
}

case "$1" in
		start)
		start
		;;
		stop)
		stop
		;;
		status)
		status
		;;
		restart)
		restart
		;;
		*)
		echo "Usage: service `basename $0` {start|stop|status|restart}"
		exit 2
		;;
esac
