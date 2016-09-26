#!/usr/bin/env bash

## Replace all occurences of foo by your service name

while [ true ]; do
  PROCCESS=`ps aux | grep serial32bits | grep -v grep | grep -v sudo`
  if [ "$PROCCESS" != "" ]; then
    PID=`echo $PROCCESS | cut -d " " -f2`
    echo $PID > /tmp/proccess-foo.pid
    MEM=`echo $PROCCESS | cut -d " " -f5`
  else
    sudo ./serial32bits &
    echo "[ INFO ] Service foo started ("$(date)")" >> /opt/services/foo/log/foo.log
  fi
  sleep 1
done
