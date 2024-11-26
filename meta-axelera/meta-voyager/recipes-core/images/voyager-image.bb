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
  ffmpeg \
  firefly-fan \
  gstreamer1.0-libav \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-ugly \
  gstreamer1.0-rockchip \
  libdrm \
  os-release \
  packagegroup-core-boot \
  python3 \
  python3-pip \
  kernel-module-axelera \
  rockchip-libmali \
  rockchip-npu-firefly \
"

IMAGE_LINGUAS = " "

require recipes-core/images/voyager.inc

IMAGE_INIT_MANAGER  = "systemd"

inherit core-image
