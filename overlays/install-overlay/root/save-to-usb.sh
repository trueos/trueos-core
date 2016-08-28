#!/bin/sh
#-
# Copyright (c) 2013 iXsystems, Inc.  All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
# Script to copy install config to a usb stick
############################################################################

if [ -z "${1}" ] ; then
   echo "Missing arg 1 - Config nickname"
   exit 1
fi
NICK=`echo "$1" | sed 's| |_|g'`

# Set the location of pc-sysinstall config
SYSCFG="/tmp/sys-install.cfg"
MNTDIR="/root/usbmount"
if [ ! -d "${MNTDIR}" ] ; then
   mkdir -p ${MNTDIR}
fi
SAVECFGDIR="${MNTDIR}/pc-sys/"
SAVECFGFILE="${SAVECFGDIR}/${NICK}.cfg"

saved=1

# Lets check the various da* devices, look for a FAT32 USB mount
for i in `ls /dev/da* 2>/dev/null`
do
   sleep 2

   # Skip the install media
   glabel status | grep "${i}p3" | grep -q "TRUEOS_INSTALL"
   if [ $? -eq 0 ] ; then continue ; fi

   # Lets try to FAT mount
   mount -t msdosfs ${i} $MNTDIR
   if [ $? -ne 0 ] ; then continue ; fi

   if [ ! -d "${SAVECFGDIR}" ] ; then
      mkdir -p ${SAVECFGDIR}
   fi
   cat ${SYSCFG} | grep -v "encpass=" | grep -v "rootPass=" | grep -v "userPass=" > ${SAVECFGFILE}
   saved=0
   sync
   umount ${MNTDIR}
   echo "Saved config to USB: $i"
   break
done

if [ "$saved" = "1" ] ; then
  echo "No USB media found.."
fi

echo "Press ENTER to continue"
read tmp

exit $saved
