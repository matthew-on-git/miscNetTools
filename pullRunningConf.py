from os import path
from napalm import get_network_driver

# Instructions
print ''
print 'This script will ask for a working directory, hostname, and credentials for a device, or list of devices seperated by a space. It will then attempt to connect to those devices and copy their running config to the directory you specified named by "hostname.config"'
print ''
# Get the detes 
print 'What directory would you like to save the config backups to? (e.g. "/home/netops/switch_baks")'
working_dir = raw_input()
print 'What nos is your device running? (e.g. "nxos", "ios", "panos", etc.)'
nos = raw_input()
print 'What devices would you like to save the config backups for? (e.g. "device-01.corp.com device-02.corp.com"'
hosts_input = raw_input()
hosts = hosts_input.split()
print 'What username should I use to connect to the devices? (e.g. "admin")'
username = raw_input()
print 'What password should I use to connect to the devices? (e.g. "password")'
passwd = raw_input()
# Confirm input
print 'The working directory is (%s)' % (working_dir)
print 'The devices to backup are (%s)' % (hosts)
print 'Confirm and continue? (yes or no)'
confirm = raw_input().lower()
if confirm == 'y' or confirm == 'yes':
    # do the thing
    print 'Fetching running configs ...'
    #from napalm import get_network_driver
    driver = get_network_driver(nos)
    for device in hosts:
        host = driver(device, username, passwd)
        print 'Opening connection to %s' % device
        host.open()
        print 'Connected to %s' % device
        running_config = host.get_config(retrieve=u'running')
        with open(path.join(working_dir, "{}{}".format(device, '.conf')), 'w') as filename:
            for key, value in running_config.items():
                filename.write('%s\n' % (value))
        print 'Closing connection to %s' % device
        host.close()
        print 'Closed connection to %s' % device
else:
    print '#Operation cancelled by user#'
