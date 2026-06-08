FILESEXTRAPATHS:prepend:axelera-machine := "${THISDIR}/files:"

SRC_URI:append:axelera-machine = " \
    file://avahi-daemon.conf \
"

do_install:append:axelera-machine() {
    install -d ${D}${sysconfdir}/avahi
    install -m 644 ${WORKDIR}/avahi-daemon.conf ${D}${sysconfdir}/avahi/avahi-daemon.conf
}
