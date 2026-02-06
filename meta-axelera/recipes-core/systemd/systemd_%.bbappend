FILESEXTRAPATHS:prepend:axelera-machine := "${THISDIR}/files:"

SRC_URI:remove:axelera-machine = " \
    file://0001-meson-do-not-fail-build-with-newer-kernel-headers.patch \
"

SRC_URI:append:axelera-machine = " \
    file://systemd-pstore.service \
"

do_install:append:axelera-machine () {
    install -m 0644 ${WORKDIR}/systemd-pstore.service ${D}${systemd_unitdir}/system/
}
