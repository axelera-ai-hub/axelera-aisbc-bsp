# Build a simple, minimal root filesystem.
#
# This recipe is a simplified form of core-image-minimal.

SUMMARY = "A simple, minimal image"

IMAGE_INSTALL = "\
    dropbear \
    i2c-tools \
    packagegroup-core-boot \
    pciutils \
"

IMAGE_LINGUAS = " "

inherit core-image
