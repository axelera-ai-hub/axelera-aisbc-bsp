# We don't want mender-client service to run. Local file system updates only.
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://mender.conf \
"

do_install:append() {
    install -d ${D}/${sysconfdir}/mender
    install -m 0600 ${WORKDIR}/mender.conf ${D}/${sysconfdir}/mender/mender.conf
}

SYSTEMD_AUTO_ENABLE = "disable"
