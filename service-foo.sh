#!/usr/bin/env bash

# Service start | stop | restart | install | uninstall

## Replace all occurences of foo by your service name

PATH="$PATH:/usr/bin:/bin"

status() {
  PROCCESS=`ps aux | grep foo.jar | grep java | grep -v grep`
  if [ "$PROCCESS" == "" ]; then
    echo "0"
  else
    PID=`echo $PROCCESS_WD | cut -d " " -f2`
    echo "$PID"
  fi
}

start() {

  PROCCESS=`ps aux | grep foo.jar | grep java | grep -v grep`

  if [ "$PROCCESS" == "" ]; then
    cd /opt/services/foo/
    ./watchdog-foo.sh &
    cd -
    if [ $? -eq 0 ]; then
      echo "[ INFO ] Service foo is running ("$(date)")" >> /opt/services/foo/log/foo.log
    else
      echo "[ ERRO ] Service foo is not running ("$(date)")" >> /opt/services/foo/log/foo.log
    fi
  else
    echo "[ WARN ] Service foo is already running ("$(date)")" >> /opt/services/foo/log/foo.log
  fi
}

stop() {

  PROCCESS=`ps aux | grep foo.jar | grep java | grep -v grep`
  PROCCESS_WD=`ps aux | grep watchdog-foo.sh | grep -v service | grep -v grep`

  if [ "$PROCCESS_WD" != "" ]; then
    PID_WD=`echo $PROCCESS_WD | cut -d " " -f2`
    kill -9 $PID_WD
    if [ $? -eq 0 ]; then
      echo "[ INFO ] watchdog-foo is not running ("$(date)")" >> /opt/services/foo/log/foo.log
    else
      echo "[ ERRO ] watchdog-foo fail on stop ("$(date)")" >> /opt/services/foo/log/foo.log
    fi
  else
    echo "[ WARN ] watchdog-foo is already stopped ("$(date)")" >> /opt/services/foo/log/foo.log
  fi

  if [ "$PROCCESS" != "" ]; then
    PID=`echo $PROCCESS | cut -d " " -f2`
    kill -9 $PID
    if [ $? -eq 0 ]; then
      echo "[ INFO ] Service foo is stopped ("$(date)")" >> /opt/services/foo/log/foo.log
    else
      echo "[ ERRO ] Service foo fail on stop ("$(date)")" >> /opt/services/foo/log/foo.log
    fi
  else
    echo "[ WARN ] Service foo is already stopped ("$(date)")" >> /opt/services/foo/log/foo.log
  fi
}

restart() {
  stop
  sleep 3
  start
}

install() {
  # Create necessary directories
  echo "Creating directories tree ..."
  mkdir -p /opt/services/foo/log/
  if [ $? -eq 0 ]; then
    echo -e "\033[01;32m[  OK  ]\033[00;37m"
  else
    echo -e "\033[01;31m[ ERRO ]\033[00;37m"
  fi

  # Copy all files in installation package to the path of the service
  echo "Copying service files to the service-foo directory ..."
  cp * /opt/services/foo/
  if [ $? -eq 0 ]; then
    echo -e "\033[01;32m[  OK  ]\033[00;37m"
  else
    echo -e "\033[01;31m[ ERRO ]\033[00;37m"
  fi

  # Copy the service to /usr/bin
  echo "Copying service-foo script to /usr/bin ..."
  cp service-foo.sh /usr/bin/service-foo
  if [ $? -eq 0 ]; then
    echo -e "\033[01;32m[  OK  ]\033[00;37m"
  else
    echo -e "\033[01;31m[ ERRO ]\033[00;37m"
  fi

  # Copy the service to /etc/init.d
  echo "Copying service-foo script to /etc/init.d ..."
  cp service-foo.sh /etc/init.d/service-foo
  if [ $? -eq 0 ]; then
    echo -e "\033[01;32m[  OK  ]\033[00;37m"
  else
    echo -e "\033[01;31m[ ERRO ]\033[00;37m"
  fi

  # Included on the system startup
  echo "Registering the service-foo to start on startup system ..."
  update-rc.d service-foo defaults
  if [ $? -eq 0 ]; then
    echo -e "\033[01;32m[  OK  ]\033[00;37m"
  else
    echo -e "\033[01;31m[ ERRO ]\033[00;37m"
  fi

  # Copy logrotate to /etc/logrotate.d
  echo "Copying logrotate configuration file to /etc/logrotate.d ..."
  cp foo /etc/logrotate.d/
  if [ $? -eq 0 ]; then
    echo -e "\033[01;32m[  OK  ]\033[00;37m"
  else
    echo -e "\033[01;31m[ ERRO ]\033[00;37m"
  fi
}

uninstall() {
  # Stopping the service
  echo "Stopping the service-foo ..."
  stop
  if [ $? -eq 0 ]; then
    echo -e "\033[01;32m[  OK  ]\033[00;37m"
  else
    echo -e "\033[01;31m[ ERRO ]\033[00;37m"
  fi

  # Removing the service of /usr/bin
  echo "Removing the service-foo from /usr/bin ..."
  rm -rf /usr/bin/service-foo
  if [ $? -eq 0 ]; then
    echo -e "\033[01;32m[  OK  ]\033[00;37m"
  else
    echo -e "\033[01;31m[ ERRO ]\033[00;37m"
  fi

  # Removing the service from /etc/init.d
  echo "Removing the service-foo from /etc/init.d ..."
  rm -rf /etc/init.d/service-foo
  if [ $? -eq 0 ]; then
    echo -e "\033[01;32m[  OK  ]\033[00;37m"
  else
    echo -e "\033[01;31m[ ERRO ]\033[00;37m"
  fi

  # Unregistering the service-foo to start on startup system
  echo "Unregistering the service-foo to start on startup system ..."
  update-rc.d service-foo remove
  if [ $? -eq 0 ]; then
    echo -e "\033[01;32m[  OK  ]\033[00;37m"
  else
    echo -e "\033[01;31m[ ERRO ]\033[00;37m"
  fi

  # Removing foo from /etc/logrotate.d
  echo "Removing foo from /etc/logrotate.d"
  rm -rf /etc/logrotate.d/foo
  if [ $? -eq 0 ]; then
    echo -e "\033[01;32m[  OK  ]\033[00;37m"
  else
    echo -e "\033[01;31m[ ERRO ]\033[00;37m"
  fi

  # Excluding service dir
  echo "Excluding service-foo directory ..."
  cd /opt/services/
  rm -rf foo/
  if [ $? -eq 0 ]; then
    echo -e "\033[01;32m[  OK  ]\033[00;37m"
  else
    echo -e "\033[01;31m[ ERRO ]\033[00;37m"
  fi
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

  status )
    status
    ;;
esac
