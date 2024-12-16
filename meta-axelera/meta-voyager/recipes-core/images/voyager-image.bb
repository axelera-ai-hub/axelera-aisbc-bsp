# Build a simple, minimal root filesystem.
#
# This recipe is a simplified form of core-image-minimal.

SUMMARY = "A simple, minimal image"

IMAGE_INSTALL = " \
  axelera-container \
  bash \
  curl \
  docker \
  dropbear \
  e2fsprogs-resize2fs \
  ffmpeg \
  gstreamer1.0-libav \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-ugly \
  gstreamer1.0-rockchip \
  kernel-module-axelera \
  libdrm \
  os-release \
  packagegroup-core-boot \
  parted \
  pciutils \
  python3 \
  python3-pip \
  rockchip-libmali \
"

IMAGE_INSTALL:append:itx-3588j = " \
  firefly-fan \
  rockchip-npu-firefly \
"

IMAGE_LINGUAS = " "

require recipes-core/images/voyager.inc

IMAGE_INIT_MANAGER  = "systemd"

inherit core-image
