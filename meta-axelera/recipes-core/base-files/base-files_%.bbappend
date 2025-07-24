FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://fstab \
"

do_install:appendj() {
    install -d ${D}${sysconfdir}
    install -m 0644 ${WORKDIR}/fstab ${D}${sysconfdir}/fstab
}
