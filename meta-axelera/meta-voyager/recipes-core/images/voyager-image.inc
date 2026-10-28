IMAGE_FEATURES:append = " ssh-server-openssh read-only-rootfs"

BUILD_VARIANT = "${@'eng-' if d.getVar('AXE_ENGINEERING_BUILD') == '1' else ''}"

IMAGE_LINK_NAME = "${IMAGE_BASENAME}-${BUILD_VARIANT}${MACHINE}-${DISTRO_VERSION}"

ENG_PACKAGE = " \
  clinfo \
  htop \
  iperf3 \
  librkcrypto-test \
  lmsensors \
  minicom \
  optee-test \
  testusb \
  strace \
  stress-ng \
  u3loop \
  vulkan-tools \
  kernel-module-usbtest \
"

IMAGE_INSTALL = " \
  auditd \
  avahi-daemon \
  avahi-autoipd \
  avahi-utils \
  axelera-container \
  curl \
  docker \
  e2fsprogs-mke2fs \
  e2fsprogs-resize2fs \
  ffmpeg-rockchip \
  fio \
  gstreamer1.0-libav \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-ugly \
  gstreamer1.0-rockchip \
  gzip \
  kernel-module-axelera \
  kernel-module-g-zero \
  kernel-module-usb-f-ss-lb \
  libdrm \
  libubootenv \
  libzip \
  mender-commit-check \
  mender-files-setup \
  mender-voyager-update-module \
  networkmanager \
  networkmanager-nmcli \
  opencv \
  optee-rockchip \
  os-release \
  packagegroup-core-boot \
  packagegroup-core-selinux \
  parted \
  pciutils \
  python3 \
  python3-pip \
  rockchip-libmali \
  tar\
  u-boot-fw-utils \
  udev-conf-axelera \
  usbutils \
  voyager-sdk \
  wireguard-tools \
  xauth \
"

IMAGE_INSTALL:append:itx-3588j = " \
  bash \
  firefly-fan \
  rockchip-npu-firefly \
"

IMAGE_INSTALL:append = "${@' ' + (d.getVar('ENG_PACKAGES') or '') if d.getVar('AXE_ENGINEERING_BUILD') == '1' else ''}"

PREFERRED_VERSION:parted = "3.6"
PREFERRED_VERSION:strace = "6.9"

IMAGE_LINGUAS = " "

IMAGE_INIT_MANAGER  = "systemd"

inherit voyager-image
