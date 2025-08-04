# Machine configuration for the Firefly ITX-RK3588J product.
require conf/machine/include/rk3588.inc

PREFERRED_VERSION_linux-rockchip = "6.1%"
LINUXLIBCVERSION = "6.1-custom%"
SERIAL_CONSOLES = "115200;ttyFIQ0"

WKS_FILE = "voyager-gptdisk.wks.in"
WKS_FILE_CHECKSUM = "sha256:c0318e081b2d21cbe665e2e7f25589c5082b440f303c2cae8697d5d1f668ad28"
