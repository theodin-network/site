#!/bin/bash

if [ -d /var/src/basicstation/.git ]; then
    cd /var/src/basicstation && git fetch
    HEADHASH=$(git rev-parse HEAD)
    UPSTREAMHASH=$(git rev-parse master@{upstream})
else
    rm -rf /var/src/basicstation
    git clone https://github.com/lorabasics/basicstation.git /var/src/basicstation
    cd /var/src/basicstation
    HEADHASH=0
    UPSTREAMHASH=1
fi

if [ "$HEADHASH" != "$UPSTREAMHASH" ]; then
    git reset --hard && git pull && \
    make clean && make platform=rpi variant=std && \
    systemctl stop station.service && \
    cp -R /var/src/basicstation/build-rpi-std/bin/station /usr/local/sbin/ && \
    cp -R /var/src/basicstation/build-rpi-std/lib/* /usr/local/lib/ && \
    cp -R /var/src/basicstation/build-rpi-std/include/* /usr/local/include/ && \
    systemctl start station.service
fi