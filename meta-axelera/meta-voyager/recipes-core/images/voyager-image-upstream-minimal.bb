# Build a simple, minimal root filesystem.
#
# This recipe is a simplified form of core-image-minimal.

SUMMARY = "A simple, minimal image"

IMAGE_FEATURES:append = " \
    splash \
    weston \
"

IMAGE_INSTALL:append = "\
    dropbear \
    glmark2 \
    gstreamer1.0 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    i2c-tools \
    kernel-modules \
    kmscube \
    linux-firmware-mali-csffw-arch108 \
    mesa-demos \
    mesa-megadriver \
    packagegroup-core-boot \
    pciutils \
    python3 \
    python3-pip \
    wayland \
    weston-xwayland \
    xauth \
    xhost \
    xwayland \
"

IMAGE_LINGUAS = " "

inherit core-image
