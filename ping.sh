#!/bin/bash

HOSTS="graph.facebook.com"
COUNT=3
ETC_HOSTS=/etc/hosts

for myHost in $HOSTS
do
        count=$(ping -c $COUNT $myHost | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
        ip=$(ping -c 1 graph.facebook.com | gawk -F'[()]' '/PING/{print $2}')
        echo "Host : $myHost with IP Address $ip is up (ping is comming) at $(date)"
        matches_in_hosts="$(grep -n $myHost /etc/hosts | cut -f1 -d:)"
        host_entry="${ip} ${myHost}"

if [ ! -z "$matches_in_hosts" ]
then
    echo "Found existing hosts entry."
  if [ -n "$(grep $myHost /etc/hosts)" ]
then
        echo "$myHost Found in your $ETC_HOSTS,...";
        #sudo sed -i".bak" "/$myHost/d" $ETC_HOSTS
    else
        echo "$myHost was not found in your $ETC_HOSTS";
    fi
    while read -r line_number; do
        #sudo sed -i '' "${line_number}s/.*/${host_entry} /" /etc/hosts
        echo "Nothing is going to update";
    done <<< "$matches_in_hosts"
else
    echo "Adding new hosts entry for $myHost with IP Address $ip."
    echo "$host_entry" | sudo tee -a /etc/hosts > /dev/null
fi

done
