# Copyright (C) 2019, Fuzhou Rockchip Electronics Co., Ltd
# Released under the MIT license (see COPYING.MIT for the terms)

SRCREV_rkbin = "fd46174432fbfdbdd3274bcd94990fd81185ae51"
SRCREV_tools = "1a32bc776af52494144fcef6641a73850cee628a"

SRC_URI = " \
	git://gitlab.com/firefly-linux/rkbin.git;protocol=https;nobranch=1;branch="rk3588/firefly";name=rkbin \
	git://github.com/JeffyCN/mirrors.git;protocol=https;branch=tools;name=tools;destsuffix=git/extra \
"
