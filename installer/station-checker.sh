#!/bin/bash

HOSTNAME=`hostname -s`
URL=`cat /etc/basicstation/cups.uri`

if [ `curl -s ${URL}/api/v3/gs/gateways/${HOSTNAME}/connection/stats |grep '"protocol":"ws"' |wc -l` != 1 ]; then
  sleep 15
  if [ `curl -s ${URL}/api/v3/gs/gateways/${HOSTNAME}/connection/stats |grep '"protocol":"ws"' |wc -l` != 1 ]; then
    sleep 15
    if [ `curl -s ${URL}/api/v3/gs/gateways/${HOSTNAME}/connection/stats |grep '"protocol":"ws"' |wc -l` != 1 ]; then
      sleep 15
      if [ `curl -s ${URL}/api/v3/gs/gateways/${HOSTNAME}/connection/stats |grep '"protocol":"ws"' |wc -l` != 1 ]; then
        touch /var/log/station-checker.log
        echo "`date` - Station offline, rebooting" >> /var/log/station-checker.log
        reboot
      fi
    fi
  fi
fi
