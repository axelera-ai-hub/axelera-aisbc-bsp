# Build a simple, minimal root filesystem.
#
# This recipe is a simplified form of core-image-minimal.

SUMMARY = "A simple, minimal image"

inherit extrausers

# Force gid 1000 to ensure that the Ubuntu user in the docker container,
# and the axelera group on the host have the same GID. This allows permissions
# between the Ubuntu user in the docker container to be shared between the host
# and the container.
EXTRA_USERS_PARAMS = "\
    groupadd docker; \
    groupadd -g 1000 axelera; \
"

PASSWORD:itx-3588j = "\$1\$moraR.7A\$pfg9OHFPwNoI0xsrPGsHX/"
USERNAME:itx-3588j = "firefly"
PASSWORD:antelao-3588 = "\$1\$fK445h2M\$JFznFB4S6TEAxsGSd/jXE/"
USERNAME:antelao-3588 = "antelao"

EXTRA_USERS_PARAMS += " useradd -p '${PASSWORD}' ${USERNAME}; "
EXTRA_USERS_PARAMS += " usermod -p '\$1\$duJ3gRL2\$Ixot1IIHoh.8B9HqKn1D./' root; "
EXTRA_USERS_PARAMS += " usermod -aG docker ${USERNAME}; "
EXTRA_USERS_PARAMS += " usermod -aG axelera ${USERNAME}; "

IMAGE_INSTALL = " \
  auto-extend-partition \
  axelera-container \
  clinfo \
  curl \
  docker \
  dropbear \
  e2fsprogs-resize2fs \
  e2fsprogs-mke2fs \
  ffmpeg-rockchip \
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
  minicom \
  networkmanager \
  networkmanager-nmcli \
  opencv \
  os-release \
  packagegroup-core-boot \
  parted \
  pciutils \
  python3 \
  python3-pip \
  rockchip-libmali \
  tar\
  udev-conf-axelera \
  wireguard-tools \
"

IMAGE_INSTALL:append:itx-3588j = " \
  bash \
  firefly-fan \
  rockchip-npu-firefly \
"

PREFERRED_VERSION:parted = "3.6"
PREFERRED_VERSION:strace = "6.9"

IMAGE_LINGUAS = " "

require recipes-core/images/voyager.inc

IMAGE_INIT_MANAGER  = "systemd"

inherit core-image

ROOTFS_POSTPROCESS_COMMAND:append = " do_change_home_ownerships; "

do_change_home_ownerships() {
    if [ -d "${IMAGE_ROOTFS}/home/firefly" ]; then
        chown -R firefly:axelera "${IMAGE_ROOTFS}/home/firefly"
        chmod 0775 "${IMAGE_ROOTFS}/home/firefly"
    fi
    if [ -d "${IMAGE_ROOTFS}/home/antelao" ]; then
        chown -R antelao:axelera "${IMAGE_ROOTFS}/home/antelao"
        chmod 0775 "${IMAGE_ROOTFS}/home/antelao"
    fi
}
