#! /bin/bash
. /etc/kerbynet.conf

# Per ottenere info sui gruppi:
# ldapsearch -x -h 127.0.0.1 -Dcn=Manager,dc=example,dc=com -w renatolocigno63 > out.txt;
# Uso: script ./remove.sh TMP 40

ADMINPWD= ## INSERT ADMIN PASSWORD HERE ##
KRB5=`cat $REGISTER/system/k5/realm`
LDAP=`cat $REGISTER/system/ldap/base`
PREFIX=$2
SIZE=$1

for i in `seq 1 $SIZE`
do
	if [ $i -lt 10 ]
	then
		CURRENTNUMBER=00$i
	elif [ $i -ge 10 ] && [ $i -lt 100 ]
	then
		CURRENTNUMBER=0$i
	else
		CURRENTNUMBER=$i
	fi


	echo "delete_principal $PREFIX$CURRENTNUMBER" > kerberos_rm.cmd
	echo "yes" >> kerberos_rm.cmd
	echo "exit" >> kerberos_rm.cmd

	echo "ldapdelete -x -h 127.0.0.1 -Dcn=Manager,$LDAP -w $ADMINPWD uid=$PREFIX$CURRENTNUMBER,ou=People,$LDAP" > removeuser_tmp.sh
	echo "kadmin.local <kerberos_rm.cmd" >>removeuser_tmp.sh
	chmod +x removeuser_tmp.sh

	./removeuser_tmp.sh > /dev/null
done

rm removeuser_tmp.sh
