#!/bin/bash

USERID=${USERID:-1000}
GROUPID=${GROUPID:-1000}

groupmod -o -g "$GROUPID" runuser
usermod -o -u "$USERID" runuser

chown runuser:runuser /home/runuser
chown runuser:runuser /dev/stdout
chown -R runuser:runuser /etc/freeradius
chown -R runuser:runuser /etc/ssl/private/

exec env HOST_IP="$(/sbin/ip route | awk '/default/ { print $3 }')" gosu runuser supervisord
