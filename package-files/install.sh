#!/bin/sh

STAGEDIR=$1
TYPE=$2
#TYPE: [ core, desktop, server ]

if [ -z "${TYPE}" ] ; then
  #invalid type
  exit 1
fi
#
tar cvf - -C ${TYPE} . | tar xvf - -C ${STAGEDIR}

#Ensure owner of files are all set to root:wheel
if [ -n "${STAGEDIR}" ] ; then
  for i in `find ${STAGEDIR}`
  do
    chown "root:wheel" ${i}
  done
fi

exit 0
