This script is used to get haproxy up and running quickly on a host. It can also be used via cron to make sure the service is up and running with the latest config file sourced from your location of choice (e.g. sftp site you use to keep a central updated config for multiple nodes)

DISCLAIMER:
    There are much better ways to manage multiple systems' apps and configs (e.g. puppet, chef, salt, etc...). This is usefull for one-off type applications where you don't want to connect a box to your internal infrastructure automation, or need to have the service running on a few machines and want something lightweight. 

Done:
- Pseudocode

Todo:
- Installs haproxy (Centos 7)
- Copies an example config
- Distribution detection
- Get haproxy running as a service