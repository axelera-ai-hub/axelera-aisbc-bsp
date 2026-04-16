require linux-axelera-mainline.inc

SRC_URI[sha256sum] = "bb7f6d80b387c757b7d14bb93028fcb90f793c5c0d367736ee815a100b3891f0"

SRC_URI += "\
    file://0001-Add-antelao-support-to-linux.patch \
    file://0002-arm64-dts-rockchip-Update-rk3588-axe-sbc-dts-to-matc.patch \
    file://axelera.cfg \
    file://axelera-mainline.cfg \
"
