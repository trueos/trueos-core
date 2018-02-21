#!/bin/sh
#Simple script to check for the standardized user directories and create them as needed
# NOTE: This tool will export a bunch of XDG_* environment variables as well
if [ -x /usr/local/bin/xdg-user-dirs-update ] ; then
  xdg-user-dirs-update
fi
