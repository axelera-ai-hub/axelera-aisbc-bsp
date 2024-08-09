# Build a simple, minimal root filesystem.
#
# This recipe is a simplified form of core-image-minimal.

SUMMARY = "A simple, minimal image"

IMAGE_INSTALL = " \
  dropbear \
  gstreamer1.0-rockchip \
  libdrm \
  packagegroup-core-boot \
  rockchip-libmali \
"

IMAGE_LINGUAS = " "

require recipes-core/images/voyager.inc

IMAGE_INIT_MANAGER  = "systemd"

inherit core-image
