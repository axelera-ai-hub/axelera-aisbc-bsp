# Build a simple, minimal root filesystem with wayland and weston.

SUMMARY = "A voyager image with Wayland and Weston"

require voyager-image.bb

IMAGE_FEATURES:append = " splash hwcodecs weston"

SYSTEMD_DEFAULT_TARGET = "graphical.target"

IMAGE_INSTALL:append = " wayland"
