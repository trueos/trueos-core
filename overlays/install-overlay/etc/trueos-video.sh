#!/bin/sh
# Load the vesa driver for the installer 
###################################################################

if [ `sysctl -n machdep.bootmethod` = "BIOS" ] ; then
  cp /root/cardDetect/XF86Config.compat /etc/X11/xorg.conf
else
  cp /root/cardDetect/XF86Config.scfb /etc/X11/xorg.conf
fi
