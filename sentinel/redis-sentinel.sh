#!/bin/sh
#
#chkconfig: 2345 80 90
# Simple Redis init.d script conceived to work on Linux systems
# as it does use of the /proc filesystem.
REDISPORT=26379
EXEC=/usr/local/bin/redis-server
CLIEXEC=/usr/local/bin/redis-cli
PIDFILE=/redis/redis-${REDISPORT}.pid
CONF="/redis/${REDISPORT}.conf"
PASSWD=123456
source /etc/init.d/functions
start() {
if [ -f $PIDFILE ]
then
echo "$PIDFILE exists, process is already running or crashed"
else
echo "Starting Redis server..."
$EXEC $CONF --sentinel
fi
}
stop() {
if [ ! -f $PIDFILE ]
then
echo "$PIDFILE does not exist, process is not running"
else
PID=$(cat $PIDFILE)
echo "Stopping ..."
$CLIEXEC -p $REDISPORT -a $PASSWD shutdown
while [ -x /proc/${PID} ]
do
echo "Waiting for Redis to shutdown ..."
sleep 1
done
echo "Redis stopped"
fi
}
status() {
if [ -f $PIDFILE ] && netstat -tnl | grep $REDISPORT &>/dev/null
then
echo "`basename $0` is running,PID is `cat $PIDFILE`"
else
echo "`basename $0` is stopped."
fi
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
