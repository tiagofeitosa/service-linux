#!/usr/bin/env bash

## Replace all occurences of foo by your service name

while [ true ]; do
  PROCCESS=`ps aux | grep foo.jar | grep java | grep -v grep`
  if [ "$PROCCESS" != "" ]; then
    echo $PROCCESS >> /tmp/proccess-foo.log
    PID=`echo $PROCCESS | cut -d " " -f2`
    MEM=`echo $PROCCESS | cut -d " " -f5`
  else
    java -jar foo.jar &
    echo "[ INFO ] Service foo started ("$(date)")" >> /opt/services/foo/log/foo.log
  fi
  sleep 1
done
