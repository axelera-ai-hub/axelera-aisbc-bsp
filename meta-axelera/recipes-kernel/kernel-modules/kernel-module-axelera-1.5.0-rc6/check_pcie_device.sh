#!/bin/sh

# File to track whether a reboot has already occurred
TRACK_FILE="/data/pcie_reboot_done"

# Check if the reboot was already performed
if [ -f "$TRACK_FILE" ]; then
  echo "Reboot already performed; skipping further checks."
  # Ensure the next power-on will cause a reboot again
  rm "$TRACK_FILE"
  exit 0
fi

# Check for the PCIe device
if lspci -nn | grep -qi "1f9d"; then
  echo "PCIe device with vendor ID 1f9d found. No action required."
  echo 1 > /sys/bus/pci/devices/0000:01:00.0/axlaipu_restore
else
  echo "PCIe device with vendor ID 1f9d not found. Initiating a single reboot."
  touch "$TRACK_FILE"
  /sbin/reboot
fi
