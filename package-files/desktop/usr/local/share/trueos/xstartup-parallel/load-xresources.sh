#!/bin/sh

#Load any old X11 settings (requires compiler in addition to relevant files/tools)
if [ -x /usr/local/bin/xrdb ] && [ -e ~/.Xresources ] ; then
  xrdb ~/.Xresources
fi
