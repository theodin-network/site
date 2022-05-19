#!/bin/bash

echo "Restarting the CE0 pin..."
CSPIN=8
echo "$CSPIN" > /sys/class/gpio/export
sleep 1
echo "out" > /sys/class/gpio/gpio$CSPIN/direction
echo "0" > /sys/class/gpio/gpio$CSPIN/value
sleep 1
echo "1" > /sys/class/gpio/gpio$CSPIN/value
echo "Done\n"
sleep 1

echo "Restarting the Concentrator..."
RSTPIN=17
echo "$RSTPIN" > /sys/class/gpio/export
sleep 1
echo "out" > /sys/class/gpio/gpio$RSTPIN/direction
echo "1" > /sys/class/gpio/gpio$RSTPIN/value
sleep 1
echo "0" > /sys/class/gpio/gpio$RSTPIN/value
echo "Done\n"
sleep 2