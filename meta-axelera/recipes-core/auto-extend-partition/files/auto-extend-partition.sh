#!/bin/sh

MARKER_FILE="/factory/auto-extend-partition.done"

if [ -f "$MARKER_FILE" ]; then
  exit 0;
fi

echo "auto-extend-partition: Partition extension process starting..." > /dev/kmsg
parted -sf /dev/mmcblk0 resizepart 5 100% || { echo "parted command failed in auto-extend-partition script."; exit 1; }
resize2fs /dev/mmcblk0p5 || { echo "resize2fs command failed in auto-extend-partition script."; exit 1; }
echo "auto-extend-partition: Partition extended successfully." > /dev/kmsg
touch "$MARKER_FILE"
