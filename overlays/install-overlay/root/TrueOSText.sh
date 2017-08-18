#!/bin/sh
# TrueOS System Install Menu
# Copyright 2016 iXsystems, Inc.
# http://www.trueos.com
# Author: Kris Moore
###########################################################################

. /root/functions.sh

while
i="1"
do

dialog --title "TrueOS Server Installation Menu" --menu "Please select from the following options:" 20 55 15 install "Start text install" utility "System Utilities" reboot "Reboot the system" 2>/tmp/answer

ANS="`cat /tmp/answer`"

case $ANS in
    install) /usr/local/bin/pc-installdialog ;;
    utility) /root/TrueOSUtil.sh
              clear ;;
     reboot)  reboot -q ;;
          *) ;;
esac

done
