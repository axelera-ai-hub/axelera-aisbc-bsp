# Copyright (C) 2019, Fuzhou Rockchip Electronics Co., Ltd
# Released under the MIT license (see COPYING.MIT for the terms)

SRCREV_rkbin = "12660714c81be85350a4092542e2ff599aa5adcb"
SRCREV_tools = "84ecd06fbd2d2a6a1320bc6813a184d4a0bb9fb8"

SRC_URI = " \
	git://gitea@gitea.amarulasolutions.com:38745/axelera/rk-binary-native.git;protocol=ssh;nobranch=1;branch=rk3588;name=rkbin \
	git://gitea@gitea.amarulasolutions.com:38745/axelera/tools.git;protocol=ssh;branch=rk3588;name=tools;destsuffix=git/extra \
"
