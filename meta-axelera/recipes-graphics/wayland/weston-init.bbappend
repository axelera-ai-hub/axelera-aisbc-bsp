FILESEXTRAPATHS:prepend:axelera-machine := "${THISDIR}/files:"

SRC_URI:append:axelera-machine = " \
    file://axelera-background.jpg \
    file://weston.ini \
"

do_install:append:axelera-machine() {
    install -d ${D}/${datadir}/backgrounds/
    install -m 0644 ${WORKDIR}/axelera-background.jpg ${D}/${datadir}/backgrounds/
}

FILES:${PN} += "\
    ${datadir}/backgrounds/axelera-background.jpg \
"
