# Copyright (C) 2024, Rockchip Electronics Co., Ltd
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-kernel/linux/cve-exclusion_6.1.inc
require recipes-kernel/linux/linux-yocto.inc
require linux-rockchip.inc

inherit local-git

SRCREV = "dc3599307cb89b70ed76412a1190a32b32690bbf"
SRC_URI = " \
	git://gitea@gitea.amarulasolutions.com:38745/axelera/linux-rockchip.git;protocol=ssh;branch=rk3588; \
	file://${THISDIR}/files/cgroups.cfg \
	file://${THISDIR}/files/axelera.cfg \
	file://${THISDIR}/files/firefly.cfg \
"

LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

KERNEL_VERSION_SANITY_SKIP = "1"
LINUX_VERSION ?= "6.1.84"

SRC_URI:append = " ${@bb.utils.contains('IMAGE_FSTYPES', 'ext4', \
		   'file://${THISDIR}/files/ext4.cfg', \
		   '', \
		   d)}"
