#!/bin/bash
if [ $# -lt 2 ]; then
    release="stable"
fi
release=$1
VERSION=`ls /home/www/debs/$release/snack_* | cut -d"_" -f2 | cut -d"_" -f1`
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
sed -e "s/Version: .*/Version: $NEWVERSION/" -i paquet_deb/DEBIAN/control
sed -e "s/SNACK 1.0/SNACK $NEWVERSION/" -i paquet_deb/home/snack/interface/app/View/Layouts/default.ctp
#dpkg-deb --build paquet_deb "snack_"$NEWVERSION"_$release_deb7u1_all.deb"
#mv /home/www/debs/$release/*.deb /home/www/debs/archives
#cp "snack_"$NEWVERSION"_$release_deb7u1_all.deb" /home/www/debs/$release
#cd /home/www/debs && ./scriptRepo.sh

