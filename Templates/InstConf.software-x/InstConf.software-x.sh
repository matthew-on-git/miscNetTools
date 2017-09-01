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


# Is package already installed
INSTALLED = ''

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
function logging() {
    if [ $LOG = "1" ] 
    then exec >> $LOG_LOCATION 2>&1
}

#Help Function
function usage() {
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
function OStell() {
    echo "Attempting to install for $PRETTYNAME"
}

#Get package name
function getPackageName () {
    if [ $ID = centos ]; then PKG = $CENTOS_PKG
    elif [ $ID = debian ]; then PKG = $DEBIAN_PKG
    elif [ $ID = ubuntu ]; then PKG = $UBUNTU_PKG
    else 
        echo 'Unable to detect OS distro. Install may fail.'
    fi
}

#Get install command
function getInstallCommand () {
    if [ $ID = centos ]; then INSTALL_CMD = $CENTOS_INST
    elif [ $ID = debian ]; then INSTALL_CMD = $DEBIAN_INST
    elif [ $ID = ubuntu ]; then INSTALL_CMD = $UBUNTU_INST
    fi
}
#Get update command
function updateCMD() {
    if [ $ID = centos ]; then UPDATE_CMD = $CENTOS_UPDT
    elif [ $ID = debian ]; then UPDATE_CMD = $DEBIAN_UPDT
    elif [ $ID = ubuntu ]; then UPDATE_CMD = $UBUNTU_UPDT
    fi
    
}
#Check if package is installed
function isInstalled () {
    if [ $ID = centos ]; then INSTALLED = `rpm -qa | grep $PKG`
    elif [ $ID = debian ]; then INSTALLED = `dpkg-query -W -f='${Status} ${Version}\n' $PKG`
    else [ $ID = ubuntu ]; then INSTALLED = `dpkg-query -W -f='${Status} ${Version}\n' $PKG`
    fi

}

#Install software
function installPKG() {
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

 
#Login to resource server
function connectArtServer() {
    #login to sftp server
}

#Check for new versions of config files
function verCheck() {
    #diff local and remote files
}

#Update config files
function replaceConfs() {
    if [ $LOCCONF = $REMOTECONF ]; #if different
    then echo "Running most current configs; no change."
    else
        #replace conf files
    fi
}



## === Main === ##