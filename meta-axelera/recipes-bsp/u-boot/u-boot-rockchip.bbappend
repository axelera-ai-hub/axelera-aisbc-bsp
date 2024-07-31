# Copyright (C) 2019, Fuzhou Rockchip Electronics Co., Ltd
# Released under the MIT license (see COPYING.MIT for the terms)

SOC_FAMILY ?= "rk3588"
CPU_SERIES = "RK3588"

inherit local-git

SRCREV_rkbin = "fd46174432fbfdbdd3274bcd94990fd81185ae51"

SRCREV_uboot = "f83f9138f588e918effaa200da488f0eb0d5afc1"

SRC_URI = " \
	git://gitlab.com/firefly-linux/u-boot.git;protocol=https;branch="rk3588/firefly";name=uboot; \
	git://gitlab.com/firefly-linux/rkbin.git;protocol=https;branch="rk3588/firefly";name=rkbin;destsuffix=rkbin; \
"

SRC_URI:append = " ${@bb.utils.contains('CPU_SERIES', 'RK356X', 'file://${CURDIR}/rk356x/0001-add-firefly-rk3566_defconfig.patch', '', d)} \
${@bb.utils.contains('CPU_SERIES', 'RK356X', 'file://${CURDIR}/rk356x/0002-remove-python2-check.patch', '', d)}"

# rk3399 not need the patch
SRC_URI:remove = " ${@bb.utils.contains('SOC_FAMILY', 'rk3399', 'file://${CURDIR}/u-boot/0001-HACK-Support-python3-for-dtoc.patch', '', d)} "
