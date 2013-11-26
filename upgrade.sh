#!/bin/bash

PAQUETNAME=snack
VERSION=1.0
DATABASE=radius

INTERFACE_USER=www-data
USER_HOME=/home/snack
ONLY_INTERFACE_ACCESS=0700
BACKUP_CONFIG_SCRIPT=$USER_HOME/scripts/backupConfig.sh
BACKUP_CREATE_SCRIPT=$USER_HOME/scripts/backup_create.sh
BACKUP_TRAPS_SCRIPT=$USER_HOME/scripts/backup_traps.sh


whiptail \
	--title "SNACK ${VERSION}" \
	--yes-button "Start" \
	--no-button "Cancel" \
	--yesno "\nWelcome !\n\nYou are upgrading SNACK.\n\nAll errors are logged in /tmp/snack_upgrade_errors.log\nStdout are logged in /tmp/snack_upgrade_out.log" \
	15 70

if [ $? != 0 ]; then
	whiptail \
		--title "SNACK ${VERSION}" \
		--msgbox "\n\nUser has canceled the installation!" \
		10 70
	exit 1
fi
RES=`rsync -avr paquet/home/snack/scripts /home/snack`
if [ "$RES" -ne "1" ]; then
    echo 20 | whiptail \
	--title "SNACK ${VERSION}" \
	--gauge "\n\n Copying new files of web interface..." 10 70 0    
fi
RES=`chown -R $INTERFACE_USER $USER_HOME/scripts`
if [ "$RES" -ne "1" ]; then
    echo 40 | whiptail \
	--title "SNACK ${VERSION}" \
	--gauge "\n\n Copying new files of web interface..." 10 70 0    
fi
RES=`chmod -R $ONLY_INTERFACE_ACCESS $USER_HOME/scripts`
if [ "$RES" -ne "1" ]; then
    echo 60 | whiptail \
	--title "SNACK ${VERSION}" \
	--gauge "\n\n Copying new files of web interface..." 10 70 0    
fi
RES=`chown snmp:snack $BACKUP_CREATE_SCRIPT`
RES=`chmod 0550 $BACKUP_CREATE_SCRIPT`
if [ "$RES" -ne "1" ]; then
    echo 80 | whiptail \
	--title "SNACK ${VERSION}" \
	--gauge "\n\n Copying new files of web interface..." 10 70 0    
fi
RES=`chown snmp:snack $BACKUP_TRAPS_SCRIPT`
RES=`chmod 0550 $BACKUP_TRAPS_SCRIPT`
if [ "$RES" -ne "1" ]; then
    echo 100 | whiptail \
	--title "SNACK ${VERSION}" \
	--gauge "\n\n Copying new files of web interface..." 10 70 0    
fi
whiptail \
	--title "SNACK ${VERSION}" \
	--ok-button "Finish" \
	--msgbox "\n\nUpgrade done!" \
	10 70

exit 0
