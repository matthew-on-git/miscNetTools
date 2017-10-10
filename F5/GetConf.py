""" module to get and put F5 BigIP configs """
## Requires f5-sdk (pip install f5-sdk)
import getpass
import requests
from f5.bigip import ManagementRoot
def get_host():
    """ Get th device hostname from the user via stdIN """
    host = raw_input('Please enter the F5 hostname or IP: ')
    return host
def get_usr():
    """ Get the username for auth from the user via stdIN  """
    username = raw_input('Please enter your username: ')
    return username
def get_passwd():
    """ Get the password for auth """
    passwd = getpass.getpass('Please enter your password: ')
    return passwd
def get_connect_method(host, usr, passwd):
    """ CATs auth details in to a connection method """
    mgmt = ManagementRoot(host, usr, passwd, token=True)
    return mgmt
def get_ver(mgmt):
    """ Get LTM version """
    print '## Version ##'
    version = mgmt.tmos_version
    v = 'LTM is version: {}' .format(version)
    print ''
    print v
    print ''

def get_pools(mgmt):
    """ Get a list of all pools """
    print '## POOLS: ##'
    pools = mgmt.tm.ltm.pools.get_collection()
    for pool in pools:
        print ''
        print 'Pool Name:', pool.name
        for member in pool.members_s.get_collection():
            print 'Member Name:', member.name
    print ''
def get_irules(mgmt):
    """ Get a list of all irules """
    print '## RULES: ##'
    rules = mgmt.tm.ltm.rules.get_collection()
    for r_n in rules:
        print ''
        print 'Rule Name:', r_n.name
    print ''
def main():
    """ Main App """
    requests.packages.urllib3.disable_warnings()
    host = get_host()
    usr = get_usr()
    passwd = get_passwd()
    mgmt = get_connect_method(host, usr, passwd)
    get_ver(mgmt)
    get_pools(mgmt)
    get_irules(mgmt)

if __name__ == "__main__":
    main()
