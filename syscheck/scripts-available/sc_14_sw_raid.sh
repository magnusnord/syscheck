#!/bin/bash

# Set default home if not already set.
SYSCHECK_HOME=${SYSCHECK_HOME:-"/usr/local/syscheck"}

# Import common resources
. $SYSCHECK_HOME/resources.sh

# uniq ID of script (please use in the name of this file also for convinice for finding next availavle number)
SCRIPTID=14

SW_RAID_ERRNO_1=${SCRIPTID}01
SW_RAID_ERRNO_2=${SCRIPTID}02
SW_RAID_ERRNO_3=${SCRIPTID}03



if [ "x$1" = "x--help" -o "x$1" = "x-h" ] ; then
	/bin/echo -e $SW_RAID_EXHLP
	/bin/echo -e $SW_RAID_EXHLP_1
	/bin/echo -e $SW_RAID_EXHLP_2
	/bin/echo -e $SW_RAID_EXHLP_3
elif [ "x$1" = "x--screen" -o "x$1" = "x-s" ] ; then
	PRINTTOSCREEN=1
fi

swraidcheck () {
	ARRAY=$1
        DISC=$2

        COMMAND=`mdadm --detail $ARRAY | grep $DISC `

        STATUSactive=`echo $COMMAND | grep 'active sync' `
        STATUSfault=`echo $COMMAND | grep 'fault' `
        if [ "x$STATUSactive" != "x" ] ; then
		# ok
                printlogmess $INFO $SW_RAID_ERRNO_1 "$SW_RAID_DESCR_1" "$ARRAY / $DISC"
        elif [ "x$STATUSfault" != "x" ] ; then
		# fault
                printlogmess $ERROR $SW_RAID_ERRNO_2 "$SW_RAID_DESCR_2" "$ARRAY / $DISC ($COMMAND)"
        else
		# failed some other way
                printlogmess $ERROR $SW_RAID_ERRNO_3 "$SW_RAID_DESCR_3" "$ARRAY / $DISC ($COMMAND)"

        fi
}
swraidcheck /dev/md0 /dev/hda1
swraidcheck /dev/md0 /dev/hde1
swraidcheck /dev/md1 /dev/hda2
swraidcheck /dev/md1 /dev/hde2

