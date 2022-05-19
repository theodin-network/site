#! /bin/bash
GATEWAY_EUI=""
GATEWAY_EUI_NIC="eth0"
if [ `grep "routerid" /etc/basicstation/station.conf |wc -l` == 1 ]; then
    GATEWAY_EUI="`grep routerid /etc/basicstation/station.conf |awk '{print $2}' |sed 's/"//g' |sed 's/,//g'`"
else
    if [[ `grep "$GATEWAY_EUI_NIC" /proc/net/dev` == "" ]]; then
        GATEWAY_EUI_NIC="wlan0"
    fi

    if [[ `grep "$GATEWAY_EUI_NIC" /proc/net/dev` == "" ]]; then
        GATEWAY_EUI_NIC="usb0"
    fi

    if [[ `grep "$GATEWAY_EUI_NIC" /proc/net/dev` == "" ]]; then
        echo "ERROR: No network interface found. Cannot set gateway ID."
        exit 1
    fi
    GATEWAY_EUI=$(ip link show $GATEWAY_EUI_NIC | awk '/ether/ {print $2}' | awk -F\: '{print $1$2$3"FFFE"$4$5$6}')
    GATEWAY_EUI=${GATEWAY_EUI^^}
fi
HOSTNAME_LOWER=`hostname -s |sed 's/gate/Gate/g'`
HOSTNAME="$(tr '[:lower:]' '[:upper:]' <<< ${HOSTNAME_LOWER:0:1})${HOSTNAME_LOWER:1}"
LORAWAN_SERVER=`cat /etc/basicstation/cups.uri`

echo "" > /etc/motd
echo "LoRaWAN Gateway: $HOSTNAME" >> /etc/motd
echo "LoRaWAN Gateway EUI: $GATEWAY_EUI" >> /etc/motd
echo "LoRaWAN Server: $LORAWAN_SERVER" >> /etc/motd
if [ ! -f /etc/basicstation/cups.key ]; then echo "cups.key file is MISSING" >> /etc/motd; fi
echo "" >> /etc/motd