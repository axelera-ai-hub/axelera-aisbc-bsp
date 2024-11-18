# Copyright (C) 2021, Rockchip Electronics Co., Ltd
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-kernel/linux/linux-yocto.inc
require linux-rockchip.inc

inherit local-git

PATCHPATH = "${THISDIR}/linux-rockchip_5.10"
inherit auto-patch

SRCREV = "a30d5a5e2455f04b855fdd8aacbf0ec832004202"

SRC_URI = " \
	git://gitlab.com/firefly-linux/kernel.git;protocol=https;nobranch=1;branch="rk3588/firefly"; \
	file://${THISDIR}/files/cgroups.cfg \
	file://${THISDIR}/files/axelera.cfg \
"

LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

KERNEL_VERSION_SANITY_SKIP = "1"
LINUX_VERSION ?= "5.10.198"

SRC_URI:append = " ${@bb.utils.contains('IMAGE_FSTYPES', 'ext4', \
		   'file://${THISDIR}/files/ext4.cfg', \
		   '', \
		   d)} \
		   file://${THISDIR}/files/yocto.cfg"

do_patch:append() {
	sed -i 's/-I\($(BCMDHD_ROOT)\)/-I$(srctree)\/\1/g' \
		${S}/drivers/net/wireless/rockchip_wlan/rkwifi/bcmdhd/Makefile
}
