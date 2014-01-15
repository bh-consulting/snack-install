#!/bin/bash

VERSION=`grep Version paquet/DEBIAN/control | cut -d" " -f2`
REV=`echo $VERSION | cut -d"-" -f2`
RAC=`echo $VERSION | cut -d"-" -f1`
if [[ "$REV" == "$VERSION" ]]; then
    NEWVERSION="$VERSION-1"
else
    NEWREV=$((REV+1))
    NEWVERSION="$RAC-$NEWREV"
fi

whiptail \
    --title "Version Number" \
    --yesno "The future version recommanded is $NEWVERSION \n Are you agree ?" \
    --yes-button "Yes" \
    --no-button "No I will change" \
    15 70
if [[ $? == 1 ]]; then
    NEWVERSION=$(whiptail --inputbox "Enter the version number you want?" 8 78 --title "Version Number" 3>&1 1>&2 2>&3)
fi
sed -e "s/Version: $VERSION/Version: $NEWVERSION/" -i paquet/DEBIAN/control
dpkg-deb --build paquet_deb "snack_"$NEWVERSION"_deb7u1_all.deb"
