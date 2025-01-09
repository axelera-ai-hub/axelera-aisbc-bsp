# Build a simple, minimal root filesystem.
#
# This recipe is a simplified form of core-image-minimal.

SUMMARY = "A simple, minimal image"

inherit extrausers

EXTRA_USERS_PARAMS:append:itx-3588j = "useradd -p '\$5\$n.d2SD190GZItUvJ\$YuFQVXzbgsdN/Ku6ACR6fq1d2M72N9Wg31.0lamahhC' firefly"
EXTRA_USERS_PARAMS:append:antelao-3588 = "useradd -p '\$5\$L7cOVUOwlfdgicw/\$mzVadqHcAl.NLkCKWPm76.M2SL61Y0bEvQLU3XVKZb7' antelao"

IMAGE_INSTALL = " \
  auto-extend-partition \
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
  htop \
  kernel-module-axelera \
  libdrm \
  lmsensors \
  os-release \
  packagegroup-core-boot \
  parted \
  pciutils \
  python3 \
  python3-pip \
  rockchip-libmali \
  udev-conf-axelera \
"

IMAGE_INSTALL:append:itx-3588j = " \
  firefly-fan \
  rockchip-npu-firefly \
"

PREFERRED_VERSION:parted = "3.6"

IMAGE_LINGUAS = " "

require recipes-core/images/voyager.inc

IMAGE_INIT_MANAGER  = "systemd"

inherit core-image
