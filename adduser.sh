#!/bin/bash
. /etc/kerbynet.conf

ADMINPWD=# INSERT ADMIN PASSWORD HERE#
LENPASS=10
MASKPASS="a-z0-9"
STARTUSER=$1

if [ ! -e "/Database/utente" ]
then
   echo 0 >/Database/utente
fi

KRB5=`cat $REGISTER/system/k5/realm`
LDAP=`cat $REGISTER/system/ldap/base`

CONTA=`cat /Database/utente`

CONTA=$((CONTA+1))
CONTAST=$((CONTA))

UIDN=$((CONTA+1000))

if (($CONTA < 10)); then
   CONTAST="0"$CONTAST
fi

if (($CONTA < 100)); then
   CONTAST="0"$CONTAST
fi

if [ ! -e "output.txt" ]
then
   echo 0 >output.txt
fi

echo $CONTA > /Database/utente

echo "$STARTUSER$CONTAST" >>output.txt

PASSWORD=$(cat /dev/urandom | tr -dc ${MASKPASS}|head -c${LENPASS})
echo "$PASSWORD" >>output.txt

rm -f user.ldif
rm -f kerberos.cmd

echo "dn: uid=$STARTUSER$CONTAST, ou=People, $LDAP" >user.ldif
echo "objectClass: inetOrgPerson" >>user.ldif
echo "objectClass: posixAccount" >>user.ldif
echo "objectClass: top" >>user.ldif
echo "objectClass: shadowAccount" >>user.ldif
echo "objectClass: organizationalPerson" >>user.ldif
echo "uid: $STARTUSER$CONTAST" >>user.ldif
echo "cn: ?" >>user.ldif
echo "description: ?" >>user.ldif
echo "displayName: ?" >>user.ldif
echo "o: ?" >>user.ldif
echo "mail: ?" >>user.ldif
echo "givenName: ?" >>user.ldif
echo "telephoneNumber: ?" >>user.ldif
echo "sn: ?" >>user.ldif
echo "uidNumber: $UIDN" >>user.ldif
echo "gidNumber: 2" >>user.ldif # TO BE CHANGED
echo "gecos: ?" >>user.ldif
echo "homeDirectory: /home/$STARTUSER$CONTAST" >>user.ldif
echo "loginShell: /bin/sh" >>user.ldif
echo "shadowExpire: 24836" >>user.ldif

echo -n export IEOPWD=>ieopass.sh
slappasswd -s$PASSWORD >>ieopass.sh
chmod +x ieopass.sh
. ./ieopass.sh > /dev/null

echo "userPassword: $IEOPWD " >>user.ldif
echo "" >>user.ldif
echo "" >>user.ldif


echo "add_principal -pw $PASSWORD -policy default $STARTUSER$CONTAST@$KRB5" >kerberos.cmd
echo "quit" >>kerberos.cmd


echo "ldapadd -x -h 127.0.0.1 -Dcn=Manager,$LDAP -w $ADMINPWD -f user.ldif" >createuser.sh
echo "kadmin.local <kerberos.cmd" >>createuser.sh
chmod +x createuser.sh

#echo $STARTUSER$CONTAST >$STARTUSER$CONTAST
#echo $PASSWORD >>$STARTUSER$CONTAST
#echo $NAME1 >>$STARTUSER$CONTAST
#echo $NAME2 >>$STARTUSER$CONTAST
#echo $MAIL >>$STARTUSER$CONTAST
#echo $PHONE >>$STARTUSER$CONTAST

. ./createuser.sh  > /dev/null
