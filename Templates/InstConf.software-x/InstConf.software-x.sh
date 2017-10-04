#!/bin/bash

## === Variables === ##

## Package name to install (Make sure to set the package
## name for all the distros )
PKG = ''
CENTOS_PKG = 'software-x-C'
DEBIAN_PKG = 'software-x-D'
UBUNTU_PKG = 'software-x-U'

## Prereq packages (Make sure to set the package
## names for all the distros )
PREREQS = ''
#CENTOS_PREREQS = ( prereq1 prereq2 )
#DEBIAN_PREREQS = ( prereq1 prereq2 )
#UBUNTU_PREREQS = ( prereq1 prereq2 )

## OS Distro and version -- For available variables see:
## https://www.freedesktop.org/software/systemd/man/os-release.html
source /etc/os-release

# Install command sequence
INSTALL_CMD = 'yum install'
CENTOS_INST = 'yum install'
DEBIAN_INST = 'apt-get update && apt-get install'
UBUNTU_INST = 'apt-get update && apt-get install'

# Update command sequence
UPDATE_CMD = 'yum update'
CENTOS_UPDT = 'yum update'
DEBIAN_UPDT = 'apt-get update && apt-get update'
UBUNTU_UPDT = 'apt-get update && apt-get update'

# Service status command
STATUS_CMD = "service ${PKG} status"


# Is package already installed
INSTALLED = ''

# Is service running
RUNNING = ''

## === Flags === ##
#Dry run only (make no changes)
TEST=0
#Update (y or n)
UPDATE=0
#Log (y or n)
LOG=1
#Log location
LOG_LOCATION='/var/log/InstConf.log'


## === Functions === ##
# Logging
function logging {
    if [ $LOG = "1" ] 
    then exec >> $LOG_LOCATION 2>&1
}

# OS detection for setting variables
funcion osDetect {
    if [ $ID = centos ]; then
        PKG = $CENTOS_PKG
        INSTALL_CMD = $CENTOS_INST
        UPDATE_CMD = $CENTOS_UPDT
    elif [ $ID = debian ]; then
        PKG = $DEBIAN_PKG
        INSTALL_CMD = $DEBIAN_INST
        UPDATE_CMD = $DEBIAN_UPDT
    elif [ $ID = ubuntu ]; then
        PKG = $UBUNTU_PKG
        INSTALL_CMD = $UBUNTU_INST
        UPDATE_CMD = $UBUNTU_UPDT
    else 
        echo 'Unable to detect OS distro. Install may fail.'
    fi
}

#Help Function
function usage {
  echo "
  usage: $0 options
  This script is used to get <software.package.x> up and running quickly on a host. It can also be used via cron to make sure the service is up and running with the latest config file sourced from your location of choice (e.g. sftp site you use to keep a central updated config for multiple nodes)

DISCLAIMER:
    There are much better ways to manage multiple systems' apps and configs (e.g. puppet, chef, salt, etc...). This is usefull for one-off type applications where you don't want to connect a box to your internal infrastructure automation, or need to have the service running on a few machines and want something lightweight. 
 
    OPTIONS:
  -h      Show this message
  -u      Update package if allready installed. Running without this flag ignores updates.
  -l      Logging (default is on use [-l no] to turn off logging)
  -o      Log location (default is "/var/log/InstConf.log")
  -t      Test (dont run any commands, but print them to the command line)
"
}

#Find OS distro
function OStell {
    echo "Attempting to install for $PRETTYNAME"
}

#Check if package is installed
function isInstalled {
    if [ $ID = centos ]; then INSTALLED = `rpm -qa | grep $PKG`
    elif [ $ID = debian ]; then INSTALLED = `dpkg-query -W -f='${Status} ${Version}\n' $PKG`
    else [ $ID = ubuntu ]; then INSTALLED = `dpkg-query -W -f='${Status} ${Version}\n' $PKG`
    fi

}

#Install software
function installPKG {
    if [ $INSTALLED = "" ]; # If package is not installed, 
    then $INSTALL_CMD $PREREQS $PKG
    else # Update package
        if [ UPDATE = 'y' or 'Y' ]; # If update flag is yes 
        then UPDATE_CMD $PKG # attempt update package
        else
            echo "Update flag not set; skipping update."
        fi
    fi
}

#Check to see if servic is running
function isRunning {
    # if statement for running service and if not bounce and 
    
    if serviceStatus
}
 
#Use Rsync to sync conf files
function updateConfs {
    #login to sftp server using rsync and sync files
}




## === Main === ##

main () {
    while getopts "h a:u:f:m:x:v:t" OPTION
    do
        case $OPTION in
            h)
                usage
                exit 1
            ;;
            a)
                ACTION=$OPTARG
            ;;
            u)
                USER=$OPTARG
            ;;
            f)
                FILE=$OPTARG
            ;;
            m)
                MESSAGE=$OPTARG
            ;;
            v)
                VERBOSE=1
            ;;
            t)
                TEST=1
            ;;
            ?)
                usage
                exit
            ;;
        esac
    done
    logging
    osDetect
    isInstalled
    installPKG
    isRunning


}
main