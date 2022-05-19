#!/bin/sh

if [ "`echo $CUPS_KEY`" != "" ]; then
    mkdir -p /etc/basicstation
    echo "Authorization: Bearer $CUPS_KEY" | perl -p -e 's/\r\n|\n|\r/\r\n/g'  > /etc/basicstation/cups.key
fi

apt update; apt -y upgrade; apt -y autoremove; apt -y install git vim multitail watchdog

rm -rf /var/src/basicstation && \
if [ `lsmod | grep spi_ |wc -l` != 1 ]; then echo "dtparam=spi=on" >> /boot/config.txt; fi && \
mkdir -p /var/src/ && git clone https://github.com/lorabasics/basicstation.git /var/src/basicstation; \
cd /var/src/basicstation && make platform=rpi variant=std && \
cp -R /var/src/basicstation/build-rpi-std/bin/station /usr/local/sbin/ && \
cp -R /var/src/basicstation/build-rpi-std/lib/* /usr/local/lib/ && \
cp -R /var/src/basicstation/build-rpi-std/include/* /usr/local/include/ && \
echo 'dtparam=watchdog=on' >> /boot/config.txt && \
curl -Ls "https://theodin.network/installer/watchdog.conf" \
-o /etc/watchdog.conf && \
curl -Ls "https://theodin.network/installer/station-loader.sh" \
-o /usr/local/bin/station-loader.sh && chmod 755 /usr/local/bin/station-loader.sh && \
curl -Ls "https://theodin.network/installer/station.service" \
-o /etc/systemd/system/station.service && systemctl enable station.service && \
mkdir -p /etc/basicstation && echo "https://console.theodin.network:443" > /etc/basicstation/cups.uri && \
curl -Ls "https://letsencrypt.org/certs/lets-encrypt-r3.der" -o /etc/basicstation/cups.trust && \
curl -Ls "https://theodin.network/installer/station.conf" \
-o /etc/basicstation/station.conf && echo '1.1.0' > /etc/basicstation/version.txt && \
curl -Ls "https://theodin.network/installer/station-updater.sh" \
-o /usr/local/sbin/station-updater.sh && chmod 750 /usr/local/sbin/station-updater.sh && \
curl -Ls "https://theodin.network/installer/build-motd.sh" \
-o /usr/local/sbin/build-motd.sh && chmod 750 /usr/local/sbin/build-motd.sh && \
curl -Ls "https://theodin.network/installer/station-checker.sh" \
-o /usr/local/bin/station-checker.sh && chmod 750 /usr/local/bin/station-checker.sh && \
if [ `grep 'build-motd.sh' /etc/rc.local |wc -l` != 1 ]; then sed -i '/^exit.*/i /usr/local/sbin/build-motd.sh' /etc/rc.local; fi && \
echo '0   2 * * * sleep ${RANDOM:0:2}m; /usr/local/sbin/station-updater.sh
0 */6 * * * sleep ${RANDOM:0:2}m; /usr/local/bin/station-checker.sh' |crontab && \
reboot
