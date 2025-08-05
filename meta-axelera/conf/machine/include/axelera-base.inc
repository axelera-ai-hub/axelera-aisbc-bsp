# Machine configuration for the Firefly ITX-RK3588J product.
require conf/machine/include/rk3588.inc

PREFERRED_VERSION_linux-rockchip = "6.1%"
LINUXLIBCVERSION = "6.1-custom%"
SERIAL_CONSOLES = "115200;ttyFIQ0"

WKS_FILE = "voyager-gptdisk.wks.in"
WKS_FILE_CHECKSUM = "sha256:6f4ca85eb6a09bb4ff244f1cfe7029f52215a230780533658b8b7357f67f877a"

# /etc overlayfs configuration
OVERLAYFS_ETC_MOUNT_POINT = "/data"
OVERLAYFS_ETC_DEVICE = "/dev/mmcblk0p6"
OVERLAYFS_ETC_FSTYPE ?= "ext4"
OVERLAYFS_ETC_MOUNT_OPTIONS = "defaults,noatime"
OVERLAYFS_ETC_INIT_TEMPLATE = "${TOPDIR}/../meta-axelera/meta/files/overlayfs-etc-preinit.sh.in"
OVERLAYFS_ETC_USE_ORIG_INIT_NAME = "0"
