# Build a simple, minimal root filesystem.
#
# This recipe is a simplified form of core-image-minimal.

SUMMARY = "A simple, minimal image"

IMAGE_FEATURES:append = " \
    splash \
    ssh-server-openssh \
    weston \
"

IMAGE_INSTALL:append = "\
    clinfo \
    clpeak \
    e2fsprogs-resize2fs \
    glmark2 \
    gstreamer1.0 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    i2c-tools \
    kernel-modules \
    kmscube \
    libopencl-mesa \
    linux-firmware-mali-csffw-arch108 \
    mesa-demos \
    mesa-megadriver \
    mesa-vulkan-drivers \
    openssh \
    packagegroup-core-boot \
    parted \
    pciutils \
    python3 \
    python3-pip \
    usbutils \
    vulkan-tools \
    vulkan-loader \
    wayland \
    weston-xwayland \
    xauth \
    xhost \
    xwayland \
"

IMAGE_LINGUAS = " "

inherit core-image
