SRC_URI:prepend:firefly-rk3588 = "git://gitlab.com/firefly-linux/external/gstreamer-rockchip.git;protocol=https;nobranch=1;branch=rk3588/linux_yocto_release; "
SRC_URI:remove:firefly-rk3588 = "git://github.com/JeffyCN/mirrors.git;protocol=https;branch=gstreamer-rockchip;"
SRCREV:firefly-rk3588 = "99fee386662a6ec46b54a8bc0de193dc7a9cb828"
PACKAGECONFIG:append:firefly-rk3588 = "\
  mpp \
  rga \
"

SRC_URI:prepend:itx-3588j = "git://gitlab.com/firefly-linux/external/gstreamer-rockchip.git;protocol=https;nobranch=1;branch=rk3588/linux_yocto_release; "
SRC_URI:remove:itx-3588j = "git://github.com/JeffyCN/mirrors.git;protocol=https;branch=gstreamer-rockchip;"
SRCREV:itx-3588j = "99fee386662a6ec46b54a8bc0de193dc7a9cb828"
PACKAGECONFIG:append:itx-3588j = " \
  mpp \
  rga \
"
