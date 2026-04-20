FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://axelera-background.jpg \
    file://weston.ini \
    file://weston.service \
"

do_install:append() {
    install -d ${D}/${datadir}/backgrounds/
    install -m 0644 ${UNPACKDIR}/axelera-background.jpg ${D}/${datadir}/backgrounds/
    install -D -p -m0644 ${UNPACKDIR}/weston.service ${D}${systemd_system_unitdir}/weston.service
}

FILES:${PN} += "\
    ${datadir}/backgrounds/axelera-background.jpg \
"
