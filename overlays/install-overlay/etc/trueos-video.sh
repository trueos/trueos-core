#!/bin/sh
# Load the vesa driver for the installer 
###################################################################

# First check if we are running as a VirtualBox guest
pciconf -lv | grep -q "VirtualBox"
if [ $? -eq 0 ] ; then 
  cp /root/cardDetect/XF86Config.virtualbox /etc/X11/xorg.conf
  kldload vboxguest 
  return
fi

if [ `sysctl -n machdep.bootmethod` = "BIOS" ] ; then
  cp /root/cardDetect/XF86Config.compat /etc/X11/xorg.conf
else
  cp /root/cardDetect/XF86Config.scfb /etc/X11/xorg.conf
fi
