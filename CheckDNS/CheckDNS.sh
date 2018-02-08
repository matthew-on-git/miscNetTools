#!/bin/bash

## Cofiguration Variables ##############################

### add hosts to check seperated by a single space
### e.g. [( www.example1.com www.example2.com )]
declare -a HOSTNAMES
hostnames=( www.mellordesign.net www.q3hosting.com )

### Installed path (default: /opt)
installedPath="/opt"

### Email address to notify of changes
### add emails seperated by a single space
### e.g. ["name1@example.com name2@example.com"]
mailto="group@example.com"

### Log file location (default: /var/log)
LOG_LOCATION="/var/log"
########################################################

# Logging
exec >> $LOG_LOCATION/CheckDNS.log 2>&1
# Initialize states directory
[ ! -e ${installedPath}/CheckDNS/states ] && mkdir -p ${installedPath}/CheckDNS/states
# Timestamp function
timestamp() {
  date "+%Y-%m-%d_%T" 
}

for h in "${hostnames[@]}"
do
    [ ! -e ${installedPath}/CheckDNS/states/${h}.state ] && touch ${installedPath}/CheckDNS/states/${h}.state
    stateFile=${installedPath}/CheckDNS/states/${h}.state
    stateFileRead=`cat ${installedPath}/CheckDNS/states/${h}.state`
    queriedNS=`nslookup ${h} | grep Server | awk '{print $2}'`
    resolvedName=`nslookup ${h} | grep Name | awk '{print $2}'`
    resolvedIP=`nslookup ${h} | grep Address | awk '{print $2}' | tail -1`
    
    output(){
        echo 'hostname:'$h";"NS:$queriedNS";"resolvedName:$resolvedName";"resolvedIP:$resolvedIP
    }
    logOutput(){
        echo $(timestamp)";"'hostname:'$h";"NS:$queriedNS";"resolvedName:$resolvedName";"resolvedIP:$resolvedIP
    }

    newFileRead=$(output)

    if [ "$stateFileRead" = "$newFileRead" ]; then
        logOutput
    else
        echo -e $(timestamp)"\nOld Value: $stateFileRead \nNew Value: $newFileRead" > $installedPath/CheckDNS/mailBody.txt
        mailSubject="*** Name resolution for ${h} has changed! ***"
        mailBody=`cat $installedPath/CheckDNS/mailBody.txt`
        echo -e "$mailBody"| mail -s "$mailSubject" $mailto 
        changeOutput(){
            echo $(timestamp)"$mailSubject"
            echo $(timestamp)"**Old Value: $stateFileRead"
            echo $(timestamp)"**New Value: $newFileRead"
        }
        changeOutput
        output > ${stateFile}
    fi
  
done
