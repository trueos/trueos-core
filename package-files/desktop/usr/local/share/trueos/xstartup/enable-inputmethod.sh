#!/bin/sh

# If you want to unconditionally enable input method modify ~/.xprofile
# by adding the line:  FORCEIBUS=YES

# default to NO if not set in ~/.xprofile
: ${FORCEIBUS:="NO"}

# Do not modify below
##########################################################################

# Check if this lang needs ibus
case ${LANG} in
  ja_JP*)
  #ibus_initialize "mozc-jp"
  ENABLE="YES"
  ;;
  ko_KR*)
  #ibus_initialize "m17n:ko:romaja"
  ENABLE="YES"
  ;;
  zh_CN*)
  #ibus_initialize "pinyin"
  ENABLE="YES"
  ;;
  zh_TW*)
  #ibus_initialize "chewing"
  ENABLE="YES"
  ;;
  *) ENABLE="NO" ;;
esac

# If the user requested to enable input method manually
if [ "${FORCEIBUS}" = "YES" ]; then
  ENABLE="YES"
fi

# If we are using input method, set vars and enable daemon
if [ "${ENABLE}" = "YES" ] && [ -x /usr/local/bin/fcitx ] ; then

  #GTK_IM_MODULE="fcitx" ; export GTK_IM_MODULE
  GTK_IM_MODULE="xim"  ; export GTK_IM_MODULE	# For GTK3
  QT_IM_MODULE="fcitx"   ; export QT_IM_MODULE
  XMODIFIERS="@im=fcitx" ; export XMODIFIERS

  /usr/local/bin/fcitx -r -d &
fi
