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

echo "Starting X in 5 seconds, press ENTER for menu"
read -t 5 tmp
if [ $? -eq 0 ] ; then
  echo "Pressed ENTER"
else
  #/opt/startx
fi

exit 0
