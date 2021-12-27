#!/bin/bash

if [ ! -z "$1" ]; then

    ping -c1 $1 >/dev/null
    if [ $? -eq 0 ]; then
        echo 'Setting Proxy...'
        echo 'http_proxy="http://'$1':3128/"' >>/etc/environment
        echo 'https_proxy="http://'$1':3128/"' >>/etc/environment
        echo '/etc/environment...'
        cat /etc/environment

        touch /etc/apt/apt.conf.d/proxy.conf
        echo 'Acquire::http::Proxy "http://'$1':3128";' >>/etc/apt/apt.conf.d/proxy.conf
        echo 'Acquire::https::Proxy "http://'$1':3128";' >>/etc/apt/apt.conf.d/proxy.conf
        echo '/etc/apt/apt.conf.d/proxy.conf...'
        cat /etc/apt/apt.conf.d/proxy.conf

        exit 0
    else
        echo 'First image creation, proxy not set.'
    fi
fi
