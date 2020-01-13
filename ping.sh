#/bin/bash

HOSTS="graph.facebook.com"
COUNT=3
ETC_HOSTS=/etc/hosts

for myHost in $HOSTS
do
	count=$(ping -c $COUNT $myHost | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
	ip=$(ping -c 1 graph.facebook.com | gawk -F'[()]' '/PING/{print $2}')
	matches_in_hosts="$(grep -n $myHost /etc/hosts | cut -f1 -d:)"
	host_entry="${ip} ${myHost}"

if [ $count -eq 3 ]; then
  echo "Host : $myHost with IP Address $ip is up (ping is comming) at $(date)"
fi

if [ $count -eq 0 ]; then
  echo "Host : $myHost with IP Address $ip is down (ping is not comming) at $(date)"
  #echo "$myHost Found in your $ETC_HOSTS,...";
  #sudo sed -i".bak" "/$myHost/d" $ETC_HOSTS
  #echo "$host_entry" | sudo tee -a /etc/hosts > /dev/null
fi

if [ ! -z "$matches_in_hosts" ]
then
   # echo "Found existing hosts entry."
  if [ -n "$(grep $myHost /etc/hosts)" ]
then
        echo "$myHost Found in your $ETC_HOSTS, Removing it now...";
        sudo sed -i".bak" "/$myHost/d" $ETC_HOSTS
    else
        echo "$myHost was not found in your $ETC_HOSTS";
   fi
    while read -r line_number; do
        #sudo sed -i '' "${line_number}s/.*/${host_entry} /" /etc/hosts
	echo "All Good, Kindly re-check for ping now.";
	#echo "$host_entry" | sudo tee -a /etc/hosts > /dev/null
    done <<< "$matches_in_hosts"
else
    #echo "Adding new hosts entry for $myHost with IP Address $ip in your $ETC_HOSTS"
    echo "All is Working fine without any host entry in $ETC_HOSTS";
#	echo "$host_entry" | sudo tee -a /etc/hosts > /dev/null
fi
done
