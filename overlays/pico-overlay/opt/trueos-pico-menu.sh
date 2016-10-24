#!/bin/sh

if [ -e /tmp/.trueos-pico-session ] ; then
  exit 0
fi

# Only need this script run once a session
touch /tmp/.trueos-pico-session

# Clear the screen
clear

PATH="$PATH:/usr/local/bin:/usr/local/sbin"
export PATH

# Platform specific bits
dmesg | grep -q "RPI2"
if [ $? -eq 0 ] ; then
  . /opt/RPI2/setup
fi

while :
do
  clear
  echo "Starting X in 5 seconds, press ENTER to cancel"
  read -t 5 tmp
  if [ $? -eq 0 ] ; then
    break
  else
    GETKEY="NO"
    if [ ! -e "/tmp/pico-id_rsa" ];then
      GETKEY="YES"
    fi
    if [ -e "/tmp/last_result" ] ; then
      if [ "`cat /tmp/last_result`" != "0" ] ; then
        GETKEY="YES"
      fi
    fi

    DOX="YES"
    # Check if we need a new PICO login
    if [ "$GETKEY" = "YES" ]; then
      /opt/pico-client
      if [ $? -ne 0 ] ; then
        DOX="NO"
      fi
    fi

    if [ "$DOX" = "YES" ] ; then
       startx
    else
       echo "Failed contacting PICO server.. Retry in 10 seconds"
       sleep 10
    fi
  fi
done

exit 0
