SRC_URI_machine:firefly-rk3588 = "git://gitlab.com/firefly-linux/external/gstreamer-rockchip.git;protocol=https;nobranch=1;branch=rk3588/linux_yocto_release;"
SRCREV_machine:firefly-rk3588 = "99fee386662a6ec46b54a8bc0de193dc7a9cb828"
PACKAGECONFIG:append:firefly-rk3588 = "\
  mpp \
  rga \
"

SRC_URI_machine:itx-3588j = "git://gitlab.com/firefly-linux/external/gstreamer-rockchip.git;protocol=https;nobranch=1;branch=rk3588/linux_yocto_release;"
SRCREV_machine:itx-3588j = "99fee386662a6ec46b54a8bc0de193dc7a9cb828"
PACKAGECONFIG:append:itx-3588j = " \
  mpp \
  rga \
"
