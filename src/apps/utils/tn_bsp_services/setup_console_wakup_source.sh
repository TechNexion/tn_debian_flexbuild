#!/bin/bash

UDEV_RULES_FILE="/etc/udev/rules.d/99-console-wakeup.rules"
CONSOLE=$(awk '{print $1}' /proc/consoles)
RULE="SUBSYSTEM==\"tty\", KERNEL==\"$CONSOLE\", RUN+=\"/bin/sh -c 'echo enabled > /sys/class/tty/$CONSOLE/power/wakeup'\""

echo "$RULE" | tee "$UDEV_RULES_FILE" > /dev/null

udevadm control --reload-rules
udevadm trigger
