SRC_URI:prepend:firefly-rk3588 = "git://gitlab.com/firefly-linux/external/libmali.git;protocol=https;nobranch=1;branch=rk3588/linux_yocto_release; "
SRC_URI:remove:firefly-rk3588 = "git://github.com/JeffyCN/mirrors.git;protocol=https;branch=libmali;"
SRCREV:firefly-rk3588 = "92ed60856079b982ef38a02c9f5a71802fbb4d48"

SRC_URI:prepend:itx-3588j = "git://gitlab.com/firefly-linux/external/libmali.git;protocol=https;nobranch=1;branch=rk3588/linux_yocto_release; "
SRC_URI:remove:itx-3588j = "git://github.com/JeffyCN/mirrors.git;protocol=https;branch=libmali;"
SRCREV:itx-3588j = "92ed60856079b982ef38a02c9f5a71802fbb4d48"
