# Copyright (C) 2019, Fuzhou Rockchip Electronics Co., Ltd
# Released under the MIT license (see COPYING.MIT for the terms)

SRCREV_rkbin = "12660714c81be85350a4092542e2ff599aa5adcb"
SRCREV_tools = "50034068f09b9833f3fb61f70263f4312407aac7"

SRC_URI = " \
	${REMOTE_REPOS_PREFIX}rk-binary-native.git;protocol=ssh;nobranch=1;branch=rk3588;name=rkbin \
	${REMOTE_REPOS_PREFIX}tools.git;protocol=ssh;branch=rk3588;name=tools;destsuffix=git/extra \
"
