#!/usr/bin/env bash

# Service start | stop | restart | install | uninstall

## Replace all occurences of foo by your service name

PATH="$PATH:/usr/bin:/bin"

start() {

  PROCCESS=`ps aux | grep foo.jar | grep java | grep -v grep`

  if [ "$PROCCESS" == "" ]; then
    cd /opt/foo/
    ./watchdog-foo.sh &
    cd -
    if [ $? -eq 0 ]; then
      echo "[ INFO ] Service foo is running ("$(date)")" >> /opt/foo/log/foo.log
    else
      echo "[ ERRO ] Service foo is not running ("$(date)")" >> /opt/foo/log/foo.log
    fi
  else
    echo "[ WARN ] Service foo is already running ("$(date)")" >> /opt/foo/log/foo.log
  fi
}

stop() {

  PROCCESS=`ps aux | grep foo.jar | grep java | grep -v grep`
  PROCCESS_WD=`ps aux | grep watchdog-foo.sh | grep -v service | grep -v grep`

  if [ "$PROCCESS_WD" != "" ]; then
    PID_WD=`echo $PROCCESS_WD | cut -d " " -f2`
    kill -9 $PID_WD
    if [ $? -eq 0 ]; then
      echo "[ INFO ] watchdog-foo is not running ("$(date)")" >> /opt/foo/log/foo.log
    else
      echo "[ ERRO ] watchdog-foo fail on stop ("$(date)")" >> /opt/foo/log/foo.log
    fi
  else
    echo "[ WARN ] watchdog-foo is already stopped ("$(date)")" >> /opt/foo/log/foo.log
  fi

  if [ "$PROCCESS" != "" ]; then
    PID=`echo $PROCCESS | cut -d " " -f2`
    kill -9 $PID
    if [ $? -eq 0 ]; then
      echo "[ INFO ] Service foo is stopped ("$(date)")" >> /opt/foo/log/foo.log
    else
      echo "[ ERRO ] Service foo fail on stop ("$(date)")" >> /opt/foo/log/foo.log
    fi
  else
    echo "[ WARN ] Service foo is already stopped ("$(date)")" >> /opt/foo/log/foo.log
  fi
}

restart() {
  stop
  sleep 3
  start
}

install() {
  # Create necessary directories
  mkdir -p /opt/foo/log/

  # Copy all files in installation package to the path of the service
  cp * /opt/foo/

  # Copy the service to /usr/bin
  cp service-foo.sh /usr/bin/service-foo

  # Copy the service to /etc/init.d
  cp service-foo.sh /etc/init.d/service-foo

  # Copy logrotate to /etc/logrotate.d
  cp foo /etc/logrotate.d/

  # Included on the system startup
  update-rc.d service-foo defaults
}

uninstall() {
  # Stopping the service
  stop

  # Removing the service of /usr/bin
  rm -rf /usr/bin/service-foo

  # Removing the service of /etc/init.d
  rm -rf /etc/init.d/service-foo

  # Excluding service dir
  cd /opt/foo/
  rm -rf *.sh
  cd ..
  rm -rf foo/

  # Removing foo from /etc/logrotate.d
  rm -rf /etc/logrotate.d/foo

  # Remove of the system startup
  update-rc.d service-foo remove
}

case $1 in
  install )
    install
    ;;

  uninstall )
    uninstall
    ;;

  start )
    start
    ;;

  stop )
    stop
    ;;

  restart )
    restart
    ;;
esac
