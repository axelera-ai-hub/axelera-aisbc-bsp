FILESEXTRAPATHS:prepend:axelera-machine := "${THISDIR}/files:"

SRC_URI:append:axelera-machine = " \
    file://axelera-background.jpg \
    file://weston.ini \
    file://weston.service \
"

do_install:append:axelera-machine() {
    install -d ${D}/${datadir}/backgrounds/
    install -m 0644 ${WORKDIR}/axelera-background.jpg ${D}/${datadir}/backgrounds/
    install -D -p -m0644 ${WORKDIR}/weston.service ${D}${systemd_system_unitdir}/weston.service
    sed "s%#WESTON_USER#%${WESTON_USER}%g" -i ${D}${systemd_system_unitdir}/weston.service
}

FILES:${PN} += "\
    ${datadir}/backgrounds/axelera-background.jpg \
"
