#!/bin/sh
. /etc/kerbynet.conf

KRB5=`cat $REGISTER/system/k5/realm`

PREFIX=$2
SIZE=$1
NUMBER=001

FOLDER=/User
CONFIG=$REGISTER/system/cp
DISCONNECT=$SCRIPTS/cp_disconnect

if ! [ -d $CONFIG/Connected ] ; then
	mkdir -p $CONFIG/Connected
fi

cd $CONFIG/Connected

CLIENTS=`ls -d *`

for IP in $CLIENTS;
do
	for i in `seq 1 $SIZE`
	do
		if [ $i -lt 10 ]
		then
			NUMBER=00$i
		elif [ $i -ge 10 ] && [ $i -lt 100 ]
		then
			NUMBER=0$i
		else
			NUMBER=$i
		fi

	if [[ `cat $IP$FOLDER` = $PREFIX$NUMBER@$KRB5 ]];
		then
			MAC=`cat $IP/MAC 2>/dev/null`
			USER=`cat $IP/User 2>/dev/null`
			echo "Disconnect $USER $IP $MAC"
			. $DISCONNECT $IP
	fi

	echo $IP $FOLDER $PREFIX$NUMBER@$KRB5
	done
done
