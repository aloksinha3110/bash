#!/bin/bash

HOSTS="graph.facebook.com"
COUNT=3
ETC_HOSTS="/etc/hosts"

for myHost in $HOSTS
do
  count=$(ping -c $COUNT $myHost | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
  ip=$(ping -c 1 graph.facebook.com | gawk -F'[()]' '/PING/{print $2}')
#if [ $count -eq 3 ]; then
   echo "Host : $myHost with IP Address $ip is up (ping is comming) at $(date)"
 if [ $count -eq 0 ]; then
    #addip to etc/hosts
    echo "Host : $myHost with IP Address $ip is down (ping failed) at $(date)"
    echo "Adding Facebook Graph IP address to your $ETC_HOSTS";
     if [ -n "$(grep $ip /etc/hosts)" ]
        then
            echo "IP address already exists IP: $(grep $ip $ETC_HOSTS)"
        else
            echo "Adding $ip to your $ETC_HOSTS";
            sudo -- sh -c -e "echo '$ip' >> /etc/hosts";

            if [ -n "$(grep $ip /etc/hosts)" ]
                then
                    echo "$ip was added succesfully \n $(grep $ip /etc/hosts)";
                else
                    echo "Failed to Add $ip, Try again!";
            fi
    fi
fi
        #echo "Host : $myHost with IP Address $ip is down (ping failed) at $(date)"
#fi
if [ $count -gt 3 ]; then
#remove() {
   if [ -n "$(grep -P "[[:space:]]$ip" /etc/hosts)" ]; then
       echo "$ip found in $ETC_HOSTS. Removing now...";
       try sudo sed -ie "/[[:space:]]$ip/d" "$ETC_HOSTS";
   else
       Your "$ip was not found in $ETC_HOSTS";
   fi
#}
fi
#echo "Ping is comming from IP" $ip;
done
