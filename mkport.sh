#!/bin/sh
# Helper script which will create the port / distfiles
# from a checked out git repo

#Get the current Git tag
ghtag=`git log -n 1 . | grep '^commit ' | awk '{print $2}'`

massage_subdir() {
  cd "$1"
  if [ $? -ne 0 ] ; then
     echo "SKIPPING $i"
     continue
  fi

comment="`cat Makefile | grep 'COMMENT ='`"

  echo "# \$FreeBSD\$
#

$comment
" > Makefile.tmp

  for d in `ls`
  do
    if [ "$d" = ".." ]; then continue ; fi
    if [ "$d" = "." ]; then continue ; fi
    if [ "$d" = "Makefile" ]; then continue ; fi
    if [ ! -f "$d/Makefile" ]; then continue ; fi
    echo "    SUBDIR += $d" >> Makefile.tmp
  done
  echo "" >> Makefile.tmp
  echo ".include <bsd.port.subdir.mk>" >> Makefile.tmp
  mv Makefile.tmp Makefile

}

if [ -z "$1" ] ; then
   echo "Usage: ./mkports.sh <portstree> <distfiles>"
   exit 1
fi

if [ ! -d "${1}/Mk" ] ; then
   echo "Invalid directory: $1"
   exit 1
fi

portsdir="${1}"
if [ -z "$portsdir" -o "${portsdir}" = "/" ] ; then
  portsdir="/usr/ports"
fi

if [ -z "$2" ] ; then
  distdir="${portsdir}/distfiles"
else
  distdir="${2}"
fi
if [ ! -d "$distdir" ] ; then
  mkdir -p ${distdir}
fi

echo "Sanity checking the repo..."
OBJS=`find . | grep '\.o$'`
if [ -n "$OBJS" ] ; then
   echo "Found the following .o files, remove them first!"
   echo $OBJS
   exit 1
fi

# Get the version
if [ -e "version" ] ; then
  verTag=$(cat version)
else
  verTag=$(date '+%Y%m%d%H%M')
fi

# Cleanup old distfiles
dfile="trueos-core"
rm ${distdir}/${dfile}-* 2>/dev/null


origdir=`pwd`
portcat="misc/"
for port in `ls port-files`
do
  # Copy ports files
  cd "${origdir}"
  echo "Updating port: ${portcat}${port}"

  if [ -d "${portsdir}/${portcat}${port}" ] ; then
    #echo " - Remove old port directory: ${portcat}${port}"
    rm -rf "${portsdir}/${portcat}${port}" 2>/dev/null
  fi
  #echo " - Copy over new port directory: port-files/${port} -> ${portcat}${port}"
  cp -R "${origdir}/port-files/${port}" "${portsdir}/${portcat}."

  # Set the version numbers
  #echo " - Replace the version/tag info in the port"
  sed -i '' "s|%%CHGVERSION%%|${verTag}|g" ${portsdir}/${portcat}${port}/Makefile
  sed -i '' "s|%%GHTAG%%|${ghtag}|g" ${portsdir}/${portcat}${port}/Makefile

  # Create the makesums / distinfo file
  cd "${portsdir}/${portcat}${port}"
  #echo " - Update the distinfo for the port"
  make makesum 2>/dev/null
  if [ $? -ne 0 ] ; then
    echo "Failed makesum"
    exit 1
  fi

  # Update port cat Makefile
  tcat=$(echo $portcat | cut -d '/' -f 1)
  massage_subdir ${portsdir}/${tcat}
done


#Reset a couple variables for the automation routine which runs this:
#Ports to test build
port="misc/trueos-core misc/trueos-desktop misc/trueos-server"
#pkgs to pre-install before doing the port test
pkg_dep="drm-next-kmod"

export bPort="misc/trueos-desktop"
