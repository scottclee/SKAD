#!/bin/bash

KEYFILE=/home/pi/watch_dog.key
TIME_STAMP=`date "+%Y%m%d-%H%M%S"`
CPU_SERIAL="$(cat /proc/cpuinfo | grep Serial | cut -d ':' -f 2)"
MAC_ADDRESS=`cat /sys/class/net/eth0/address | sed 's/\://g'`
KEY=$CPU_SERIAL-$MAC_ADDRESS-$TIME_STAMP
KEY_HASH=`/bin/echo $KEY | /usr/bin/md5sum | /usr/bin/cut -f1 -d" "`
echo $KEY_HASH > $KEYFILE
echo "Unique key hash: $KEY_HASH (stored in $KEYFILE)"
