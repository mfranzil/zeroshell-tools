#! /bin/bash

ITERATIONS=$1
PREFIX=$2

rm /Database/utente
rm output.txt

for i in `seq 1 $ITERATIONS`;
do
    . ./adduser.sh $PREFIX
done

rm user.ldif ieopass.sh kerberos.cmd createuser.sh -f
