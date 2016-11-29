import napalm

# Instructions
print ''
print 'This script will ask for a working directory, hostname, and credentials for a device, or list of devices seperated by a ",". It will then attempt to connect to those devices and copy their running config to the directory you specified named by "hostname.config"'
print ''
# Get the detes 
print 'What directory would you like to save the config backups to? (e.g. /home/netops/switch_baks)'
working_dir = raw_input()
print 'What nos is your device running? (e.g. nxos, ios, panos, etc.)'
nos = raw_input()
print 'What devices would you like to save the config backups for? (e.g. device-01.corp.com,device-02.corp.com'
devices = raw_input()
print 'What username should I use to connect to the devices? (e.g. admin)'
username = raw_input()
print 'What password should I use to connect to the devices? (e.g. password)'
passwd = raw_input()
# Confirm input
print 'The working directory is (%s)' % (working_dir)
print 'The devices to backup are (%s)' % (devices)
print 'Confirm and continue? (yes or no)'
confirm = raw_input().lower()
if confirm is 'y' or 'yes':
    # do the thing
    print 'Fetching running configs ...'
    driver = get_network_driver(nos)
else:
    # cancel
    print 'operation cancelled by user'
