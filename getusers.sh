#! /bin/bash

. /etc/kerbynet.conf

ADMINPWD= ## INSERT ADMIN PASSWORD HERE ##
LDAP=`cat $REGISTER/system/ldap/base`
OUTPUT=output.txt

ldapsearch -x -h 127.0.0.1 -Dcn=Manager,$LDAP -w $ADMINPWD > $OUTPUT
