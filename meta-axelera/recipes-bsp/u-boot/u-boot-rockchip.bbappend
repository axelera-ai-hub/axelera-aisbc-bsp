# Copyright (C) 2019, Fuzhou Rockchip Electronics Co., Ltd
# Released under the MIT license (see COPYING.MIT for the terms)
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SOC_FAMILY ?= "rk3588"
CPU_SERIES = "RK3588"
PROVIDES += "u-boot"

inherit local-git

SRCREV_rkbin = "12660714c81be85350a4092542e2ff599aa5adcb"
SRCREV_uboot = "4cb81ad5558dec446092422d4590d700d9815c7c"

DEPENDS += "u-boot-tools-native"

SRC_URI = " \
    ${REMOTE_REPOS_PREFIX}uboot-rockchip.git;protocol=${REMOTE_PROTOCOL};branch=rk3588;name=uboot; \
    ${REMOTE_REPOS_PREFIX}rk-binary-native.git;protocol=${REMOTE_PROTOCOL};branch=rk3588;name=rkbin;destsuffix=rkbin; \
    file://0001-add-itx-3588j_defconfig.patch; \
    file://0002-add-rockchip-environment-support.patch; \
    file://0003-use-root-instead-of-uuid-in-kernel-cmdline.patch; \
    file://0004-mender-integration-changes.patch; \
    file://0005-env-Kconfig-Make-ENV_OFFSET_REDUND-always-available.patch \
    file://0006-common-image-android-Boot-from-right-boot-partiong-u.patch \
    file://0007-tools-rockchip-Fix-string-truncation.patch \
    file://0009-common-bootm-Check-devtype-enviroment-before-strcmp.patch \
    file://0010-avb-Spoof-A-B-slot-routing-to-follow-Mender.patch \
    file://0011-android_bootloader.c-Fix-boot-crash-with-AVB-images.patch \
    file://0012-avb-Add-Rockchip-patch-to-hardcode-pubkey.patch \
    file://0013-include-configs-Enlarge-SYS_BOOTM_LEN.patch \
    file://0014-android_bootloader-Avoid-to-skip_initramfs-for-dm-ve.patch \
    file://0015-rsa-sign-Use-maximum-salt-length-for-RSA-PSS-signatu.patch \
    file://environment.cfg; \
    file://secureboot.cfg \
"

SRC_URI:append = " ${@'file://fit-signature.cfg' if d.getVar('AXE_UBOOT_SIGN_KEY_DIR') else ''}"

SRC_URI:append = " ${@bb.utils.contains('CPU_SERIES', 'RK356X', 'file://${CURDIR}/rk356x/0001-add-firefly-rk3566_defconfig.patch', '', d)} \
${@bb.utils.contains('CPU_SERIES', 'RK356X', 'file://${CURDIR}/rk356x/0002-remove-python2-check.patch', '', d)}"

# rk3399 not need the patch
SRC_URI:remove = " ${@bb.utils.contains('SOC_FAMILY', 'rk3399', 'file://${CURDIR}/u-boot/0001-HACK-Support-python3-for-dtoc.patch', '', d)} "

COMPATIBLE_MACHINE = "(itx-3588j|antelao-3588)"

include ${@mender_feature_is_enabled("mender-uboot","recipes-bsp/u-boot/u-boot-mender.inc","",d)}

SRC_URI:append:mender-uboot = " file://0008-Change-boot-strategy.patch"

do_deploy:append() {
    UBOOT_ENV_SIZE="$(cat ${B}/.config | grep "^CONFIG_ENV_SIZE=" | cut -d'=' -f2)"
    mkenvimage -s ${UBOOT_ENV_SIZE} -r ${B}/u-boot-initial-env -o ${WORKDIR}/u-boot-env.img

    install -d ${DEPLOYDIR}
    install -m 0644 ${WORKDIR}/u-boot-env.img ${DEPLOYDIR}
}

# Set RK_UBOOT_SPL so we build the SPL from source instead of the prebuilt Rockchip loader
RK_UBOOT_SPL = "${@'1' if d.getVar('AXE_UBOOT_SIGN_KEY_DIR') else ''}"

# Directory with dev.key, dev.pubkey and dev.crt used to sign the loader and
# U-Boot. Leave empty for an unsigned build.
AXE_UBOOT_SIGN_KEY_DIR ?= ""

do_compile:prepend() {
    if [ -n "${AXE_UBOOT_SIGN_KEY_DIR}" ]; then
        install -d ${B}/keys
        install -m 0600 ${AXE_UBOOT_SIGN_KEY_DIR}/dev.key ${B}/keys/
        install -m 0644 ${AXE_UBOOT_SIGN_KEY_DIR}/dev.pubkey \
                        ${AXE_UBOOT_SIGN_KEY_DIR}/dev.crt ${B}/keys/
    fi
}

do_compile:append() {
    if [ -n "${AXE_UBOOT_SIGN_KEY_DIR}" ]; then
        cd ${B}
        # Repack the idblock with the SPL built from source, not rkbin's
        ./make.sh --idblock --spl
        ln -sf idblock.bin "${RK_IDBLOCK_IMG}"

        # Sign it with the same key as the loader and U-Boot
        SIGN_TOOL=${WORKDIR}/rkbin/tools/rk_sign_tool
        ${SIGN_TOOL} cc --chip 3588
        ${SIGN_TOOL} lk --key keys/dev.key --pubkey keys/dev.pubkey
        ${SIGN_TOOL} sb --idb idblock.bin
    fi
}
