#!/bin/bash
## Tested on Centos 7.3
yum install -y libtool automake autoconf python-devel
yum install -y libpcap-devel
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/softflowd/softflowd-0.9.9.tar.gz
tar -zxvf softflowd-0.9.9.tar.gz
cd softflowd-0.9.9
./configure
make
make install
echo ".................................................."
echo ""
echo ""
echo "/usr/local/sbin/softflowd -i eth0 -v 9 -n <collector ip>:<collector port>"
echo "Place above line, with defined collector ip and port, in /etc/rc.d/rc.local or run it manually"
echo ""
echo ""