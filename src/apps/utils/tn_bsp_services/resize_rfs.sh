#!/bin/bash

# find root device
ROOT_DEVICE=$(findmnt / -o source -n)
# prune root device (for example UUID)
ROOT_DEVICE=$(realpath "${ROOT_DEVICE}")
# get the partition number and type
ROOT_PART_NAME=$(echo "$ROOT_DEVICE" | cut -d "/" -f 3)
DEVICE_NAME=$(echo /sys/block/*/"${ROOT_PART_NAME}" | cut -d "/" -f 4)
PART_ENTRY_NUMBER=$(cat "/sys/block/${DEVICE_NAME}/${ROOT_PART_NAME}/partition")

sleep 5

echo -e '\033[36m\n***********************************'
echo 'Resizing storage at first boot.....'
echo -e '***********************************\033[0m'

sudo parted -s /dev/$DEVICE_NAME "resizepart ${PART_ENTRY_NUMBER} -1" quit
sudo partprobe /dev/$DEVICE_NAME

sudo resize2fs ${ROOT_DEVICE}

sudo mount -o remount,rw /

echo -e '\033[36m\n***********************************'
echo 'Resizing task completes. Rebooting.....'
echo -e '***********************************\033[0m'
