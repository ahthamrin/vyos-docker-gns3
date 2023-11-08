#! /bin/sh
echo "replacing host-name from vyos to $HOSTNAME"
/usr/bin/sed -i "s/host-name vyos/host-name ${HOSTNAME}/g" /opt/vyatta/etc/config.boot.default
