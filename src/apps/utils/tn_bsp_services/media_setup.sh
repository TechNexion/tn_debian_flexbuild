#!/bin/bash

# For imx8mm, enable tevs <--> csis-32e30000.mipi-csi link
if (echo $HOSTNAME | grep -v imx8mm); then exit 0; fi

if [ -e /dev/media0 ]; then
    SENSOR_ENTITY="tevs 1-0048"
    CSI_ENTITY="csis-32e30000.mipi-csi"
    echo "[MediaSetup] enable link ${SENSOR_ENTITY} - ${CSI_ENTITY}"
    cmd="media-ctl -l \"'$SENSOR_ENTITY':0 -> '$CSI_ENTITY':0 [1]\""
    eval $cmd
else
    echo "/dev/media0 not exsits!"
fi
