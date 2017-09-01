#!/bin/bash
## Tested on Centos 7.3
set -e
set -x
## Install dependencies
yum install -y python-setuptools python-devel gcc
easy_install pip
pip install setuptools --upgrade
easy_install -U setuptools
## Install Elastalert
pip install elastalert
## Depending on the version of Elasticsearch, you may need to 
## manually install the correct version of elasticsearch-py.
## Elasticsearch 5.0+:
# pip install "elasticsearch>=5.0.0"
## Elasticsearch 2.X:
# pip install "elasticsearch<3.0.0"
mkdir /opt/elastalert
curl https://raw.githubusercontent.com/matthewmdn/miscNetTools/master/Elastalert/config.yaml > /opt/elastalert/config.yaml
mkdir /opt/elastalert/rules.d
curl https://raw.githubusercontent.com/matthewmdn/miscNetTools/master/Elastalert/example_frequency.yaml > /opt/elastalert/rules.d/example_frequency.yaml