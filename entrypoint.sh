#!/bin/bash

echo "starting..."
echo "$UNAME"
echo "$NETWORK"
echo "$RLOGIP"

#start cron
/usr/sbin/crond -f -l 8
