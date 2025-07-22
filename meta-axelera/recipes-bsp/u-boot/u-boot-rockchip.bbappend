# Copyright (C) 2019, Fuzhou Rockchip Electronics Co., Ltd
# Released under the MIT license (see COPYING.MIT for the terms)

SOC_FAMILY ?= "rk3588"
CPU_SERIES = "RK3588"
PROVIDES += "u-boot"

inherit local-git

SRCREV_rkbin:itx-3588j = "fd46174432fbfdbdd3274bcd94990fd81185ae51"
SRCREV_uboot:itx-3588j = "f83f9138f588e918effaa200da488f0eb0d5afc1"

SRC_URI:itx-3588j = " \
	git://gitlab.com/firefly-linux/u-boot.git;protocol=https;branch="rk3588/firefly";name=uboot; \
	git://gitlab.com/firefly-linux/rkbin.git;protocol=https;branch="rk3588/firefly";name=rkbin;destsuffix=rkbin; \
"

SRCREV_rkbin:antelao-3588 = "12660714c81be85350a4092542e2ff599aa5adcb"
SRCREV_uboot:antelao-3588 = "4cb81ad5558dec446092422d4590d700d9815c7c"

SRC_URI:antelao-3588 = " \
	${REMOTE_REPOS_PREFIX}uboot-rockchip.git;protocol=ssh;branch=rk3588;name=uboot; \
	${REMOTE_REPOS_PREFIX}rk-binary-native.git;protocol=ssh;branch=rk3588;name=rkbin;destsuffix=rkbin; \
"

SRC_URI:append = " ${@bb.utils.contains('CPU_SERIES', 'RK356X', 'file://${CURDIR}/rk356x/0001-add-firefly-rk3566_defconfig.patch', '', d)} \
${@bb.utils.contains('CPU_SERIES', 'RK356X', 'file://${CURDIR}/rk356x/0002-remove-python2-check.patch', '', d)}"

# rk3399 not need the patch
SRC_URI:remove = " ${@bb.utils.contains('SOC_FAMILY', 'rk3399', 'file://${CURDIR}/u-boot/0001-HACK-Support-python3-for-dtoc.patch', '', d)} "
