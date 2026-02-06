# We don't want mender-client service to run. Local file system updates only.
FILESEXTRAPATHS:prepend:axelera-machine := "${THISDIR}/files:"

SRC_URI:append:axelera-machine = " \
    file://mender.conf \
"

do_install:append:axelera-machine() {
    install -d ${D}/${sysconfdir}/mender
    install -m 0600 ${WORKDIR}/mender.conf ${D}/${sysconfdir}/mender/mender.conf
}

SYSTEMD_AUTO_ENABLE = "disable"
