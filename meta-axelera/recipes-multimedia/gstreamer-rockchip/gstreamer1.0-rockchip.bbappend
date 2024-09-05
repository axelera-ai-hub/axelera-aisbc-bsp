SRC_URI = "git://gitlab.com/firefly-linux/external/gstreamer-rockchip.git;protocol=https;nobranch=1;branch=rk3588/linux_yocto_release"
SRCREV = "99fee386662a6ec46b54a8bc0de193dc7a9cb828"

PACKAGECONFIG:append = "\
  mpp \
  rga \
"
