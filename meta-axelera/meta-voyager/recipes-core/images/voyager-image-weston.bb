# Build a simple, minimal root filesystem with wayland and weston.

SUMMARY = "A voyager image with Wayland and Weston"

require voyager-image.bb

EXTRA_USERS_PARAMS += " usermod -aG docker,axelera weston;"

IMAGE_FEATURES:append = " \
    hwcodecs \
    splash \
    weston \
"

SYSTEMD_DEFAULT_TARGET = "graphical.target"

IMAGE_INSTALL:append = " \
    wayland \
    weston-xwayland \
    xfce4-terminal \
    xhost \
    xwayland \
"
