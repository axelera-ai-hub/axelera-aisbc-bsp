# Machine configuration for the Firefly ITX-RK3588J product.
require conf/machine/include/rk3588.inc

PREFERRED_VERSION_linux-rockchip = "6.1%"
LINUXLIBCVERSION = "6.1-custom%"
SERIAL_CONSOLES = "115200;ttyFIQ0"

WKS_FILE = "voyager-gptdisk.wks.in"
WKS_FILE_CHECKSUM = "sha256:c9cf8ac128ea1c61ad05552243f4e4381df9fd936c7bdafc0a0810c572973869"
