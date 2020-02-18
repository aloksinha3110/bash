#!/bin/bash

HOSTS="graph.facebook.com"
ETC_HOSTS=/etc/hosts
ip_fix1="157.240.22.19"
ip_fix2="157.240.11.17"
while [ 1 ]
do

for a in {01..09}
do
echo -e "\nChecking ping test on ts0$a"
packet_loss=$(ssh "ts0$a"i ping -c 5 -q $HOSTS | grep -oP '\d+(?=% packet loss)')
ip=$(ssh "ts0$a"i ping -c 1 graph.facebook.com | gawk -F'[()]' '/PING/{print $2}')
echo $ip

if [ $packet_loss -gt 75 ]; then
	  echo -e "Host : $HOSTS is down (ping is not comming) on ts0$a at $(date)\n"
	if [ -n "$(ssh "ts0$a"i grep -n $HOSTS /etc/hosts)" ];
		then
        	echo "$HOSTS Found in your $ETC_HOSTS, Removing it now...";
		ssh "ts0$a"i sudo sed -i".bak" "/$HOSTS/d" $ETC_HOSTS
                echo "Adding new hosts entry for $HOSTS with IP Address $ip in your $ETC_HOSTS"
		host_entry="${ip_fix1} ${HOSTS}"
                echo "$host_entry" | ssh "ts0$a"i sudo tee -a /etc/hosts > /dev/null
        else
                echo "$HOSTS was not found in your $ETC_HOSTS";
        fi
elif [ $packet_loss -le 25 ] && [ $packet_loss -ge 10 ]; then
                        SUBJECT="graph.facebook.com issue detected at $(date)"
                        TOEMAIL="alok.sinha@gmail.com.com"
                        EMAILMESSAGE="/home/alok/alok_scripts/message.txt"
                        echo "Check your ping" >>$EMAILMESSAGE
                        /bin/mail -s "$SUBJECT" "$TOEMAIL" < $EMAILMESSAGE
		echo "Adding new hosts entry for $HOSTS with IP Address $ip in your $ETC_HOSTS"
		host_entry="${ip_fix1} ${HOSTS}"
		echo "$host_entry" | ssh "ts0$a"i sudo tee -a /etc/hosts > /dev/null
#	else
#		echo "$HOSTS was not found in your $ETC_HOSTS"

else
	echo "Host : $HOSTS is up (ping is comming) on ts0$a at $(date)"
	ssh "ts0$a"i sudo sed -i".bak" "/$HOSTS/d" $ETC_HOSTS

if [ $packet_loss -eq 0 ]; then
echo -e "\nI am only Storing Unique IPs in List:"

declare -A uniqs
list=($ip)
for f in "${list[@]}"; do
  uniqs["${f}"]=""
done

for stored_ip in "${!uniqs[@]}"; do
 echo "${stored_ip[0]}"
done
	fi
  fi
done
echo "============================="
echo "Will Start after Ten Sec."
echo -e "=============================\n"
sleep 10
done
