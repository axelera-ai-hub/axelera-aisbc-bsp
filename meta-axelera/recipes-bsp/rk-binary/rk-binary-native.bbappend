# Copyright (C) 2019, Fuzhou Rockchip Electronics Co., Ltd
# Released under the MIT license (see COPYING.MIT for the terms)

SRCREV_rkbin:axelera-machine = "12660714c81be85350a4092542e2ff599aa5adcb"
SRCREV_tools:axelera-machine = "50034068f09b9833f3fb61f70263f4312407aac7"

SRC_URI:axelera-machine = " \
	${REMOTE_REPOS_PREFIX}rk-binary-native.git;protocol=${REMOTE_PROTOCOL};nobranch=1;branch=rk3588;name=rkbin \
	${REMOTE_REPOS_PREFIX}tools.git;protocol=${REMOTE_PROTOCOL};branch=rk3588;name=tools;destsuffix=git/extra \
"
