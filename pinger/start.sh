#!/bin/bash
/usr/sbin/rsyslogd -n -iNONE &
cron

sleep 5

. /start_ping.sh

echo "Starting app!"

tail -f /dev/null

echo "Exiting..."
