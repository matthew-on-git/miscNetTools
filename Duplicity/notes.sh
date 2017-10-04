# Replace 'precise' with your Ubuntu version's codename.
echo deb http://ppa.launchpad.net/duplicity-team/ppa/ubuntu trusty main | \
sudo tee /etc/apt/sources.list.d/duplicity.list
sudo apt-get update
# python-boto adds S3 support
sudo apt-get install duplicity duply python-boto

## from: http://old.blog.phusion.nl/2013/11/11/duplicity-s3-easy-cheap-encrypted-automated-full-disk-backups-for-your-servers/
