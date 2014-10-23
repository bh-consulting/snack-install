#!/bin/bash

function extract_db() {
    awk -F \' "/$1.*=>.*'/ {print \$4}"\
	~snack/interface/app/Config/database.php | head -n1
}

## VARIABLES
BACKUP_PATH=/home/snack/backups.git

db_login=$(extract_db login)
db_password=$(extract_db password)
db_name=$(extract_db database)
db_host=$(extract_db host)
db_prefix=$(extract_db prefix)

TYPE_BACKUP=$1
NAS_IP_ADDRESS=$2

read sqline <<SQL
    INSERT INTO\\
    ${db_prefix}backups(datetime, nas, action, users)\\
    VALUES(NOW(), '$NAS_IP_ADDRESS', '%s', '%s')\\
SQL

read sql_sshbackupdone <<SQL
    UPDATE ${db_prefix}backups\\
    SET commit='%s'\\
    WHERE commit IS NULL\\
    AND nas='$NAS_IP_ADDRESS'\\
    ORDER BY datetime DESC\\
    LIMIT 1\\
SQL

length=8
char=(0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ! @)
max=${#char[*]}

for (( i = 1; i <= $length ; i++ ))do
        let rand=${RANDOM}%${max}
        password="${password}${char[$rand]}"
done

#echo $password
#chsh -s /bin/bash snack
#echo "snack:$password" | chpasswd
ssh snack@$NAS_IP_ADDRESS show run | sed '/^! [Last|NVRAM]/d' > $BACKUP_PATH/$NAS_IP_ADDRESS
cd ~snack/backups.git/

/usr/bin/git add $NAS_IP_ADDRESS
/usr/bin/git commit -m AUTO-COMMIT $NAS_IP_ADDRESS

commit=$(/usr/bin/git log --pretty=oneline -1 HEAD | cut -d\  -f1)

/usr/bin/mysql -h $db_host -u $db_login -p$db_password $db_name\
                -e "$(printf "$sqline" $TYPE_BACKUP ${USER_NAME//\"})"

/usr/bin/mysql -h $db_host -u $db_login -p$db_password $db_name\
    -e "$(printf "$sql_sshbackupdone" $commit)"

