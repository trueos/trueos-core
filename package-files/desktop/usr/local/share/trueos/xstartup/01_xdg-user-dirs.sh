#!/bin/sh
#Setup XDG environment variables (may be modified by DE/WM later)
export XDG_DATA_DIRS="/share:/usr/share:/usr/local/share"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_DIRS="/usr/local/etc/xdg"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_RUNTIME_DIR="/tmp/.runtime-${USERNAME}"

#Check the standardized user directories and create them as needed
# NOTE: This tool will export a bunch of XDG_* environment variables as well
if [ -x /usr/local/bin/xdg-user-dirs-update ] ; then
  xdg-user-dirs-update
fi
