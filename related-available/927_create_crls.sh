#!/bin/bash

SYSCHECK_HOME="${SYSCHECK_HOME:-/opt/syscheck}" # use default if  unset
if [ ! -f ${SYSCHECK_HOME}/syscheck.sh ] ; then
  echo "Can't find $SYSCHECK_HOME/syscheck.sh"
  exit
fi

if [ ! -f ${SYSCHECK_HOME}/syscheck.sh ] ; then echo "Can't find $SYSCHECK_HOME/syscheck.sh" ;exit ; fi

# Import common resources
source $SYSCHECK_HOME/config/related-scripts.conf

# script name, used when integrating with nagios/icinga
SCRIPTNAME=create_crls

# uniq ID of script (please use in the name of this file also for convinice for finding next availavle number)
SCRIPTID=927

# how many info/warn/error messages
NO_OF_ERR=3
initscript $SCRIPTID $NO_OF_ERR

# get command line arguments
INPUTARGS=`/usr/bin/getopt --options "hsv" --long "help,screen,verbose" -- "$@"`
if [ $? != 0 ] ; then schelp ; fi
#echo "TEMP: >$TEMP<"
eval set -- "$INPUTARGS"

while true; do
  case "$1" in
    -s|--screen  ) PRINTTOSCREEN=1; shift;;
    -v|--verbose ) PRINTVERBOSESCREEN=1 ; shift;;
    -h|--help )   schelp;exit;shift;;
    --) break;;
  esac
done


# main part of script

printtoscreen "${EJBCA_HOME}/bin/ejbca.sh ca createcrl"
CMD=$(${EJBCA_HOME}/bin/ejbca.sh ca createcrl 2>&1 | tr -d '\n'  | tr -d '\r')

RES=$(echo "$CMD" | grep "CRLs have been created.")
if [ "x$RES" = "x"  ] ; then
        printlogmess -n ${SCRIPTNAME} -i ${SCRIPTID} -x ${SCRIPTINDEX} -l $ERROR -e ${ERRNO[2]} -d "${DESCR[2]}" -1 "$CMD"
else
        printlogmess -n ${SCRIPTNAME} -i ${SCRIPTID} -x ${SCRIPTINDEX} -l $INFO -e ${ERRNO[1]} -d "${DESCR[1]}" -2 "$CMD"
fi
printtoscreen $CMD
