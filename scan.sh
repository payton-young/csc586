#!/bin/bash
#this is scan.sh
#FILE1 =


if [ ! -f "/var/lc.txt" ]
then	
  sudo echo 0 | sudo tee /var/lc.txt
fi

sudo touch /var/webserver_log/unauthorized.log
sudo chmod 775 /var/webserver_log/unauthorized.log

#LASTLINE=$(tail -1 /var/webserver_log/unauthorized.log)

#unreliable method of gathering differnces between two files
LINE_COUNT=$(sudo wc -l /var/log/auth.log | cut -d " " -f1)
OLD_LINES=$(sudo cat /var/lc.txt)
NEW_LINES=$((LINE_COUNT-OLD_LINES)) 
DATE=$(date +%D)


#think about reading last line of unauthorized log 

sudo touch holder.txt
sudo touch input.txt
sudo chmod 775 holder.txt
sudo chmod 775 input.txt


sudo tail -$NEW_LINES /var/log/auth.log > holder.txt
sudo grep sshd.\*Failed holder.txt > input.txt
 
while IFS= read -r line;
do
   #sudo echo $line
   #sudo echo $line >> /var/webserver_log/unauthorized.log
   IP_MSG_STRNG=$(sudo grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' <<< "$line") 
   COUNTRY_CODE=$(whois -l "$IP_MSG_STRNG" | sudo grep 'country' | awk '{print $2}')
   sudo echo "$line --- MALICIOUS ATTEMPT: $IP_MSG_STRNG: COUNTRY: $COUNTRY_CODE $DATE" | sudo tee -a /var/webserver_log/unauthorized.log > /dev/null
done <input.txt

sudo echo $LINE_COUNT | sudo tee /var/lc.txt >/dev/null
sudo rm holder.txt
sudo rm input.txt

