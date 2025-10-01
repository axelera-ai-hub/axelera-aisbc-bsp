# Build a simple, minimal root filesystem with wayland and weston.

SUMMARY = "Voyager image with Wayland and Weston"

require voyager-image.inc

EXTRA_USERS_PARAMS += " usermod -aG docker,axelera weston;"

IMAGE_FEATURES:append = " \
    hwcodecs \
    splash \
    weston \
    overlayfs-etc \
"

IMAGE_INSTALL:append = " \
    fontconfig \
    fontconfig-utils \
    stress-ng \
    ttf-noto-emoji-color \
    wayland \
    weston-xwayland \
    xfce4-terminal \
    xhost \
    xwayland \
"

# tools for automatic testing
IMAGE_INSTALL:append = " \
    iperf3 \
"

SYSTEMD_DEFAULT_TARGET = "graphical.target"
