#!/bin/bash

# find root device
ROOT_DEVICE=$(findmnt / -o source -n)
# prune root device (for example UUID)
ROOT_DEVICE=$(realpath "${ROOT_DEVICE}")
# get the partition number and type
ROOT_PART_NAME=$(echo "$ROOT_DEVICE" | cut -d "/" -f 3)
DEVICE_NAME=$(echo /sys/block/*/"${ROOT_PART_NAME}" | cut -d "/" -f 4)
PART_ENTRY_NUMBER=$(cat "/sys/block/${DEVICE_NAME}/${ROOT_PART_NAME}/partition")

sudo parted -s /dev/$DEVICE_NAME "resizepart ${PART_ENTRY_NUMBER} -1" quit
sudo resize2fs ${ROOT_DEVICE}
