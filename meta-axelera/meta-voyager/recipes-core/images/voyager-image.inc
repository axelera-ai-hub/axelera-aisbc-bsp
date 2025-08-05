IMAGE_FEATURES:append = " ssh-server-openssh read-only-rootfs"

IMAGE_INSTALL = " \
  auto-extend-partition \
  axelera-container \
  clinfo \
  curl \
  docker \
  e2fsprogs-mke2fs \
  e2fsprogs-resize2fs \
  ffmpeg-rockchip \
  gstreamer1.0-libav \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-ugly \
  gstreamer1.0-rockchip \
  gzip \
  htop \
  kernel-module-axelera \
  kernel-module-g-zero \
  kernel-module-usb-f-ss-lb \
  kernel-module-usbtest \
  libdrm \
  libubootenv \
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
  setup-directories \
  tar\
  testusb \
  u-boot-fw-utils \
  u3loop \
  udev-conf-axelera \
  usbutils \
  wireguard-tools \
  xauth \
"

IMAGE_INSTALL:append:itx-3588j = " \
  bash \
  firefly-fan \
  rockchip-npu-firefly \
"

PREFERRED_VERSION:parted = "3.6"
PREFERRED_VERSION:strace = "6.9"

IMAGE_LINGUAS = " "

IMAGE_INIT_MANAGER  = "systemd"

inherit voyager-image
