# Machine configuration for the Firefly ITX-RK3588J product.
require conf/machine/include/rk3588.inc

PREFERRED_VERSION_linux-rockchip = "6.1%"
LINUXLIBCVERSION = "6.1-custom%"
SERIAL_CONSOLES = "115200;ttyFIQ0"

WKS_FILE = "voyager-gptdisk.wks.in"
WKS_FILE_CHECKSUM = "sha256:dc2188b2abe2fec2ff2e3def30a661fbef6859b8f43b268ec991760226ed6962"
