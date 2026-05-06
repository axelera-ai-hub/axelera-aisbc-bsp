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
    alsa-utils \
    fontconfig \
    fontconfig-utils \
    libdrm-tests \
    mesa-demos \
    ttf-noto-emoji-color \
    wayland \
    weston-xwayland \
    xfce4-terminal \
    xhost \
    xwayland \
    linux-firmware-mali-csffw-arch108 \
    libopencl-mesa \
    mesa-vulkan-drivers \
    vulkan-tools \
    vulkan-loader \
"

# security tools
#IMAGE_INSTALL:append = " \
#    clamav \
#"

# tools for automatic testing
IMAGE_INSTALL:append = " \
    stress-ng \
    iperf3 \
"

SYSTEMD_DEFAULT_TARGET = "graphical.target"
