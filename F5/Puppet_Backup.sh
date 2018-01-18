#!/bin/bash
################################################################################
## Requires F5 puppet module, see: #############################################
## https://forge.puppet.com/f5/f5 ##############################################
################################################################################

## Variables ###################################################################
# Directory for backup files
FILES_DIR="bak"
#Timestamp
TIMESTAMP=`date "+%Y-%m-%d_%H:%M:%S"`

## Flags #######################################################################
#Dry run only (make no changes)
TEST=0
#Log (y or n)
LOG=1
#Log location
LOG_LOCATION="./$TIMESTAMP.F5_backup.log"

## Functions ###################################################################
# Logging
logging () {
    if [ $LOG = "1" ]; then 
        if [ $TEST -eq 0 ]; then
            echo "Creating log at: $LOG_LOCATION"
            exec >> $LOG_LOCATION 2>&1
        else
            echo "Creating log at: $LOG_LOCATION"
        fi
    fi
}
#Help Function
function usage {
  echo "
  usage: $0 options
 
    OPTIONS:
  -d      Device fqdn *REQUIRED*
  -h      Show this message
  -l      Logging (default is on use [-l no] to turn off logging)
  -o      Log location (default is "./TIMESTAMP.F5_backup.log")
  -p      Password *REQUIRED*
  -t      Test only. Dont run any commands, but print steps.
  -u      Username *REQUIRED*
"
}
# Make backup files directory
function bak_dir () {
    eval "BAK_DIR=${FQDN}_${FILES_DIR}"
    if [ $TEST -eq 0 ]; then
        ! [[ -d $BAK_DIR ]] && mkdir $BAK_DIR
    fi        
}
#Build FACTER_url from opts
function get_fu () {
    eval "FACTER_url=https://$USER:$PASS@$FQDN"
    echo "FACTER_url is: $FACTER_url"
}
# Loop through type
function get_types () {
    TYPES=( f5_iapp f5_node f5_pool f5_irule f5_monitor f5_virtualserver f5_partition f5_vlan f5_selfip )
    for t in "${TYPES[@]}"
    do
        echo "Backing up $t"
        if [ $TEST -eq 0 ]; then
            `FACTER_url=$FACTER_url puppet resource $t > "$BAK_DIR/$t.bak"`
        fi
    done
}
## Main ########################################################################
#Check the number of arguments. If none are passed, print help and exit.
NUMARGS=$#
echo -e \\n"Number of arguments: $NUMARGS"
if [ $NUMARGS -eq 0 ]; then
    usage
    exit 1
fi
# get options 
while getopts ":d:l:o:p:tu:h" FLAG; do
    case $FLAG in
        d)
            FQDN=$OPTARG
            echo "Backing up device: $FQDN"
        ;;
        l)
            LOG=$OPTARG
        ;;
        o)
            LOG_LOCATION="$TIMESTAMP.$OPTARG"
            if [ $LOG -eq 1 ]; then
                echo "Logging to: $LOG_LOCATION"
            fi
        ;;
        p) PASS=$OPTARG ;;
        t)
            TEST=1
            echo "Testing only. No config will be backed up."
        ;;
        u)
            USER=$OPTARG
            echo "Running under user: $USER"
        ;;
        h) usage ; exit 1 ;;
        \?) usage ; exit 1 ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
        ;;
    esac
done

shift $((OPTIND-1))
# End Options

# Run main program
function main () {
    logging
    get_fu
    bak_dir
    get_types
}
main
