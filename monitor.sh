#!/bin/bash
#monitor.sh

EMAIL_ADDR="paytonyoung821@gmail.com"
EMAIL_MSG=""
OHB=$(date --date='1 hour ago' +%u)
HOLDERSTR=$(tail -1 /var/webserver_monitor/unauthorized.log) 
LAST_READ_TIME=$(date -d "$HOLDERSTR" +%u) 
sudo touch tp.txt
sudo chmod 775 tp.txt

while read -r line;
do
	#echo this
	sudo echo $line > tp.txt 
	#cannot get single line grep to operate correctly?
	TMP= grep -o -s '[0-9][0-9]:[0-9][0-9]:[0-9][0-9]' tp.txt
	WRITE_TIME=$(date --date=TMP +%u)  	


if [[ $WRITE_TIME -gt $OHB ]]
then
	EMAIL_MSG="$EMAIL_MSG $line"	
fi

done </var/webserver_monitor/unauthorized.log



if [[ $EMAIL_MSG == "" ]] 
then
	EMAIL_MSG="NO UNAUTHORIZED ACCESS DETECTED"
fi


#sudo > /var/webserver_monitor/unauthorized.log
TODAY_DATE=$(date +%D)
sudo mail -s "SSH ACCESS LOGS FOR $TODAYDATE" $EMAIL_ADDR "$EMAIL_MSG"
