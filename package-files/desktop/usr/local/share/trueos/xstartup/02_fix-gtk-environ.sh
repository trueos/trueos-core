#!/bin/sh
#Setup GDK/Mozilla environment settings

# Fix an issue with large image rendering via mozilla
export MOZ_DISABLE_IMAGE_OPTIMIZE=1

# Detect the current DPI and try to automatically set the GTK scale factor
if [ -x /usr/local/bin/xdpyinfo ] ; then
  DPI=`xdpyinfo | grep resolution | cut -w -f 3 | cut -d x -f 1`
  #Text scaling (this would be better with floating-point accuracy in the future)
  export GDK_DPI_SCALE=`expr ${DPI} / 96`
  #All Scaling (whole numbers only)
  #export GDK_SCALE=
fi
