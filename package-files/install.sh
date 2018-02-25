#!/bin/sh

STAGEDIR=$1
TYPE=$2
#TYPE: [ core, desktop, server ]

case ${TYPE} in
  core|desktop|server) ;;
  *) exit 1 ;;
esac

echo "Installing $TYPE files -> ${STAGEDIR}"
tar cf - -C ${TYPE} . | tar xf - -C ${STAGEDIR}
if [ $? -ne 0 ] ; then
  echo "Failed installing files..."
  exit 1
fi

# Ensure owner of files are all set to root:wheel if installing as root
if [ "$(id -u)" = "0" ] ; then
    chown -R root:wheel ${STAGEDIR}
fi

sleep 2
sync

exit 0
