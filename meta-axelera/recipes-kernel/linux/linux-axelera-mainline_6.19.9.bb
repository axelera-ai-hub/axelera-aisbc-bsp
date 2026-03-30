require linux-axelera-mainline.inc

SRC_URI[sha256sum] = "c16068a3af12e3943dee3b1eef57ca70229c069128bfa1184fb3f48b219d55bf"

SRC_URI += "\
    file://0001-Add-antelao-support-to-linux.patch \
    file://0002-arm64-dts-rockchip-Update-rk3588-axe-sbc-dts-to-matc.patch \
"
