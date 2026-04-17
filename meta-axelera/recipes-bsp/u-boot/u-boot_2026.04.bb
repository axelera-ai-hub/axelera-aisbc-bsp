# Simple recipe for using mainline U-Boot

require recipes-bsp/u-boot/u-boot-common.inc
require recipes-bsp/u-boot/u-boot.inc

# Rewrite SRC_URI so we don't download the CVE patches: we fetch a more recent
# version were they have already been applied.
SRC_URI = " \
    git://source.denx.de/u-boot/u-boot.git;protocol=https;branch=master \
    file://0001-Add-antelao-support-in-u-boot.patch \
    file://0002-dts-upstream-arm64-rockchip-Update-axe-sbc-dts-to-ma.patch \
    file://0003-dts-upstream-arm64-rockchip-Add-HDMI-support-to-axe-.patch \
"

# v2026.04
SRCREV = "88dc2788777babfd6322fa655df549a019aa1e69"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=2ca5f2c35c8cc335f0a19756634782f1"

DEPENDS += "\
    gnutls-native \
    python3-pyelftools-native \
    util-linux-native \
"
