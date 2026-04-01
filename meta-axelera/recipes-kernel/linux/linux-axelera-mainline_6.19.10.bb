require linux-axelera-mainline.inc

SRC_URI[sha256sum] = "466d441a0ea5e04b7023618b7b201bfd60effab225f806fd41ce663484395a1c"

SRC_URI += "\
    file://0001-Add-antelao-support-to-linux.patch \
    file://0002-arm64-dts-rockchip-Update-rk3588-axe-sbc-dts-to-matc.patch \
    file://axelera.cfg \
    file://axelera-mainline.cfg \
"
