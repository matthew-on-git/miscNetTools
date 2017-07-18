#!/bin/bash
## logging config...
LOG_LOCATION="/var/log"    
exec >> $LOG_LOCATION/CheckDNS.log 2>&1

[ ! -e /opt/CheckDNS/states ] && mkdir -p /opt/CheckDNS/states

## hostname list 
hostnames=( api.ntent.com asgs.ntent.com )
echo '# '$(date -u)' #'
echo '.......................'

for h in "${hostnames[@]}"
do
    stateFile=`cat /opt/CheckDNS/states/${h}.state`
    echo 'resolving hostname:'$h
    lookup=`nslookup $h`
    echo '.......................'
done
echo '#########################'