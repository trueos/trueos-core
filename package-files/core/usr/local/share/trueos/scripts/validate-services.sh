#!/bin/sh
#================
# This is a script to take a couple input files for recommended/required
# services and merge those changes onto the system as needed to preserve
# user-configuration in addition to required/enforced services
#================
# Written by Ken Moore <ken@ixsystems.com>, February 2018
# Available under the 2-Clause BSD license
#================

#================
# NOTE about file format:
# There needs to be two or three words per line delimited by colons, 
# These words correspond to the CLI arguments to the rc-update utility
#====EXAMPLE====
# add:pcdm:default
# delete:dbus
# add:openmdns:boot
#================

if [ 0 != `id -u` ] ; then
  echo "This script must be run as root!!"
  exit 1
fi

#Determine the file locations
forcefile=${1:-/usr/local/etc/trueos/required-services}
recfile=${2:-/usr/local/etc/trueos/recommended-services}
recfileold=`grep -vxe '^#.*' ${recfile}.prev 2> /dev/null`

#echo "Checking files: ${forcefile} ${recfile}"

#curstate=`rc-update`
#echo "${curstate}"

parse_input(){
  # Parse the input line from a file and save it into the internal variables for use later
  #echo "Parse Input $1"
  line=$1
   _act=`echo ${line} | cut -d : -f 1`
   _service=`echo ${line} | cut -d : -f 2`
  _runlevel=`echo ${line} | cut -d : -f 3`
  #Now validate the input fields and return 0/1
  test -n "${_service}" && test "${_act}" == "add" -o "${_act}" == "delete"
  return $?
}

service_exists(){
  #Uses the pre-set ${_service} variable
  test -x /etc/init.d/${_service} -o -x /usr/local/etc/init.d/${_service}
  return $?
}

is_enabled(){
  #uses the pre-set ${_service} variable
  tmp=`rc-update | grep -w "${_service}"`
  #echo "Service is enabled: ${_service} : ${tmp}"
  test -n "${tmp}"
  return $?
}

state_same(){
  is_enabled
  ret=$?
  #echo "Service Enabled: ${ret} : ${_service}"
  if [ "delete" == "${_act}" ] ; then
    if [ $ret -eq 0 ] ; then 
      ret=1
    else 
      ret=0
    fi
  fi
  
  return ${ret}
}

#Read the recommended file
recfilecontents=`grep -vxe '^#.*' ${recfile}`
if [ "${recfilecontents}" != "${recfileold}" ] ; then
  #something changed - need to evaluate line by line
  #echo "Evaluate Recommended File Contents"
  for i in ${recfilecontents}
  do
    if ! parse_input ${i} ; then continue ; fi
    if ! service_exists ; then continue ; fi
    if state_same ; then continue ; fi
    #Now comes the complicated part
    # - see if it was the same recommendation from the old set
    # - and ignore it if so (nothing changed in recommendations - don't adjust system)
    tmp=`echo ${recfileold} | grep -w "${i}"`
    #echo "Got comparison: ${i}, ${tmp}"
    if [ -z ${tmp} ] ; then
      rc-update ${_act} ${_service} ${_runlevel}
    fi

  done
  #save the current recfile to the old file (overwriting previous version)
  cp "${recfile}" "${recfile}.prev"
fi

#Ensure the forced settings are set
if [ -e "${forcefile}" ] ; then
  for i in `grep -vxe '^#.*' ${forcefile}`
  do
    if ! parse_input ${i} ; then continue; fi
    if ! service_exists ; then continue ; fi
    if state_same ; then continue ; fi

    rc-update ${_act} ${_service} ${_runlevel}
  done
fi

exit 0
