FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = "\
    file://weston.ini \
    file://axelera-background.jpg \
"

do_install:append() {
    install -d ${D}/usr/share/backgrounds/
    install -m 0644 ${WORKDIR}/axelera-background.jpg ${D}/usr/share/backgrounds/
}

FILES:${PN} =+ " \
    /usr/share/backgrounds/axelera-background.jpg \
"
