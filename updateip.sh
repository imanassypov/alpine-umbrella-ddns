#!/bin/bash

UNAME="$1:$2"
NETWORK="$3"
RLOGIP="$4"

if [[ -z "$UNAME" || -z "NETWORK" ]]; then
   echo "One of required variables is not set"
   exit 1
fi

if [[ ! $RLOGIP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
   echo "Supplied IP:$RLOGIP is invalid"
   exit 1
fi

URL="https://updates.opendns.com/nic/update?hostname=${NETWORK}"
RESPONSE=$(curl -s -u ${UNAME} ${URL})
RCODE=$(echo $RESPONSE | cut -d" " -f1)
IP=$(echo $RESPONSE | cut -d" " -f2)
echo $RCODE
echo $IP
