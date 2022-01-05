#!/bin/bash
# install squid
apt-get update
apt-get upgrade
apt-get install squid

# check if we have the backup squid.conf, if not create one
FILE=/etc/squid/squid.conf.bk

if [ -f "$FILE" ]; then
    echo "squid.conf backup exists, no change applied"
else
    cp /etc/squid/squid.conf /etc/squid/squid.conf.bk
    echo "backup created: squid.conf.bk"
fi

# write into a new file, of custom setup
cat custom_setup >squid.conf
# move the true squis conf to our squid conf
cat /etc/squid/squid.conf.bk >>squid.conf
# copy over acl list
cp -f proxy-block-list.acl /etc/squid/
cp -f proxy-allow-list.acl /etc/squid/
# copy and overwrite original squid conf
cp -f squid.conf /etc/squid/

chmod 644 /etc/squid/squid.conf
chmod 644 /var/log/squid/cache.log

iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 3130
# start squid
service squid start
systemctl restart squid
