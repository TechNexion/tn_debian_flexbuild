#!/bin/bash

MACHINE_NAME=$(cat /proc/device-tree/model | tr -d '\0')

case "${MACHINE_NAME}" in
	*EDM-G-IMX8MM*)
		ttydev=ttymxc2
		ttybaud=3000000
		;;
	*EDM-G-IMX8MP*|*AXON-IMX8MP*|*PICO-IMX8MM*)
		ttydev=ttymxc0
		ttybaud=3000000
		;;
	*AXON-IMX93*|*EDM-IMX93*)
		ttydev=ttyLP4
		ttybaud=3000000
		;;
	*)
		;;
esac

if [ ! -z "${ttydev}" ]&&[ ! -z "${ttybaud}" ];then
	sed -i "s|\@BAUDRATE\@|${ttybaud}|g" /opt/btattach/btattach.sh
	ln -sf /usr/lib/systemd/system/serial-btattach@.timer \
		/etc/systemd/system/timers.target.wants/serial-btattach@$ttydev.timer
	systemctl enable serial-btattach@$ttydev.timer
	systemctl start serial-btattach@$ttydev.timer
else
	echo ${0##*/}: not supported device, unknown ttydev.
fi
