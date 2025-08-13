FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:remove:firefly-rk3588 = " \
    file://0001-meson-do-not-fail-build-with-newer-kernel-headers.patch \
"

SRC_URI:remove:itx-3588j = " \
    file://0001-meson-do-not-fail-build-with-newer-kernel-headers.patch \
"

SRC_URI:remove:antelao-3588 = " \
    file://0001-meson-do-not-fail-build-with-newer-kernel-headers.patch \
"
