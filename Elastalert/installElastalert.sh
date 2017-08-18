#!/bin/bash
## Tested on Centos 7.3
set -e
set -x
## Install dependencies
yum install -y python-setuptools python-devel gcc
easy_install pip
easy_install -U setuptools
pip install setuptools --upgrade
## Install Elastalert
pip install elastalert
## Depending on the version of Elasticsearch, you may need to 
## manually install the correct version of elasticsearch-py.
## Elasticsearch 5.0+:
# pip install "elasticsearch>=5.0.0"
## Elasticsearch 2.X:
# pip install "elasticsearch<3.0.0"
mkdir /opt/elastalert
mkdir /opt/elastalert/rules.d
