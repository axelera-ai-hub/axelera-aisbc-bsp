# Build a simple, minimal root filesystem.
#
# This recipe is a simplified form of core-image-minimal.

SUMMARY = "A simple, minimal image"

inherit extrausers

EXTRA_USERS_PARAMS = "\
    groupadd docker; \
"

PASSWORD:itx-3588j = "\$5\$n.d2SD190GZItUvJ\$YuFQVXzbgsdN/Ku6ACR6fq1d2M72N9Wg31.0lamahhC"
USERNAME:itx-3588j = "firefly"
PASSWORD:antelao-3588 = "\$5\$L7cOVUOwlfdgicw/\$mzVadqHcAl.NLkCKWPm76.M2SL61Y0bEvQLU3XVKZb7"
USERNAME:antelao-3588 = "antelao"

EXTRA_USERS_PARAMS += " useradd -p '${PASSWORD}' ${USERNAME}; "
EXTRA_USERS_PARAMS += " usermod -aG docker ${USERNAME}"

IMAGE_INSTALL = " \
  auto-extend-partition \
  axelera-container \
  bash \
  clinfo \
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

ROOTFS_POSTPROCESS_COMMAND:append = " do_change_home_ownerships; "

do_change_home_ownerships() {
    if [ -d "${IMAGE_ROOTFS}/home/firefly" ]; then
        chown -R firefly:firefly "${IMAGE_ROOTFS}/home/firefly"
    fi
    if [ -d "${IMAGE_ROOTFS}/home/antelao" ]; then
        chown -R antelao:antelao "${IMAGE_ROOTFS}/home/antelao"
    fi
}
