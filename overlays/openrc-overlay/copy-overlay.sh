#!/bin/sh

TPORTS="$1"

if [ -z "$TPORTS" ] ; then
  echo "Usage: $0 <portsdir>"
  exit 1
fi

if [ ! -d "${TPORTS}/Mk" ] ; then
  echo "${TPORTS} does not appear to be a ports tree"
  exit 1 
fi

# Locate all our OpenRC dirs
for pfdir in `find . | grep '/files$'`
do
  pfdir=`echo $pfdir | sed 's|^./||g'`
  pdir=`echo $pfdir | cut -d '/' -f 1-2`
  ifiles=`ls $pfdir/ | sed 's|.in$||g'`
  unset flist
  for i in $ifiles
  do
    if [ -z "$flist" ] ; then
	flist="$i"
    else
	flist="$i $flist"
    fi
  done

  if [ ! -d "${TPORTS}/${pdir}" ] ; then
    echo "WARNING: ${TPORTS}/${pdir} does not exist! Skipping..."
    continue
  fi
  echo "Adding \"$flist\" for $pdir"

  # Sed the Makefile
  sed -i '' "s|USE_RC_SUBR=.*|USE_OPENRC_SUBR=	$flist|g" ${TPORTS}/${pdir}/Makefile

  # Copy over the .in files
  for f in $flist
  do
    if [ ! -d "${TPORTS}/${pfdir}" ] ; then
      mkdir -p ${TPORTS}/${pfdir}
    fi
    cp ${pfdir}/${f}.in ${TPORTS}/${pfdir}/${f}.in
  done

done
