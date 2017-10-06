import requests, getpass
from f5.bigip import ManagementRoot
requests.packages.urllib3.disable_warnings()
host = raw_input('Please enter the F5 hostname or IP: ')
username = raw_input('Please enter your username: ')
# print "Please enter your password ..."
passwd = getpass.getpass('Please enter your password: ')
auth = ManagementRoot(host, username, passwd, token=True)
version = auth.tmos_version
v = 'LTM is version: {}' .format(version)
print v

