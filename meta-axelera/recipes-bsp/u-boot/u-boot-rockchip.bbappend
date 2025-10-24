# Copyright (C) 2019, Fuzhou Rockchip Electronics Co., Ltd
# Released under the MIT license (see COPYING.MIT for the terms)
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SOC_FAMILY ?= "rk3588"
CPU_SERIES = "RK3588"
PROVIDES += "u-boot"

inherit local-git

SRCREV_rkbin = "12660714c81be85350a4092542e2ff599aa5adcb"
SRCREV_uboot = "4cb81ad5558dec446092422d4590d700d9815c7c"

SRC_URI = " \
    ${REMOTE_REPOS_PREFIX}uboot-rockchip.git;protocol=ssh;branch=rk3588;name=uboot; \
    ${REMOTE_REPOS_PREFIX}rk-binary-native.git;protocol=ssh;branch=rk3588;name=rkbin;destsuffix=rkbin; \
    file://0001-add-itx-3588j_defconfig.patch; \
    file://0002-add-rockchip-environment-support.patch; \
    file://0003-use-root-instead-of-uuid-in-kernel-cmdline.patch; \
    file://0004-mender-integration-changes.patch; \
    file://0005-env-Kconfig-Make-ENV_OFFSET_REDUND-always-available.patch \
    file://0006-common-image-android-Boot-from-right-boot-partiong-u.patch \
    file://environment.cfg; \
"

SRC_URI:append = " ${@bb.utils.contains('CPU_SERIES', 'RK356X', 'file://${CURDIR}/rk356x/0001-add-firefly-rk3566_defconfig.patch', '', d)} \
${@bb.utils.contains('CPU_SERIES', 'RK356X', 'file://${CURDIR}/rk356x/0002-remove-python2-check.patch', '', d)}"

# rk3399 not need the patch
SRC_URI:remove = " ${@bb.utils.contains('SOC_FAMILY', 'rk3399', 'file://${CURDIR}/u-boot/0001-HACK-Support-python3-for-dtoc.patch', '', d)} "

COMPATIBLE_MACHINE = "(itx-3588j|antelao-3588)"

include ${@mender_feature_is_enabled("mender-uboot","recipes-bsp/u-boot/u-boot-mender.inc","",d)}
