#!/bin/bash
if [ -z "$dns" ]; then
        echo "Missing required DNS server IP address"
        exit
fi

if [ -z "$host" ]; then
        for s in 'beta' 'rc' 'staging'; do
                if [ "$env" == "$s" ]; then
                        echo "Using $s package repository"
                        host="$s-packages.lsfilter.com"
                fi
        done

        if [ -z "$host" ]; then
                echo "Using production package repository"
                host="packages.lsfilter.com"
        fi
fi

output=/dev/null
if [ "$verbose" == "yes" ]; then
        output=/dev/stdout
fi

echo "Updating packages ..."
apt-get update >$output 2>&1
DEBIAN_FRONTEND=noninteractive apt-get -y upgrade >$output 2>&1

echo "Checking for gnupg2"
if ! dpkg -s gnupg2 >/dev/null 2>&1; then
        echo "Installing gnupg2 ..."
        apt-get -y install gnupg2
else
        echo "gnupg2 is already installed"
fi

echo "Checking for Lightspeed package repo"
if [ -f "/etc/apt/sources.list.d/lsfilter.list" ]; then
        echo "Lightspeed package repo already configured"
else
        echo "Adding Lightspeed package repo"
        echo "deb [arch=amd64] https://$host/ubuntu bionic multiverse" | sudo tee /etc/apt/sources.list.d/lsfilter.list
        wget -O- "https://$host/public.key" | apt-key add -

        echo "Updating packages ..."
        apt-get update >$output 2>&1
fi

echo "Checking for Lightspeed packages"
if ! dpkg -s relay-rocket >/dev/null 2>&1; then
        echo "Installing Lightspeed packages ..."
        apt-get -y install relay-rocket
else
        echo "Lightspeed packages are already installed"
fi

echo "Configuring DNS"
: | tee /etc/resolv.conf
for ip in $(echo $dns | tr " " "\n"); do
        echo "nameserver $ip" | tee -a /etc/resolv.conf
done

echo "Restarting lsrelayd daemon"
svc -t /etc/lsrelayd

if [ -n "$token" ]; then
        echo "Pairing with Relay"
        lsfilterd -pair "$token"
fi

echo "Setup complete"
