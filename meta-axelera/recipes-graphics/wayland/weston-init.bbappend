FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = "\
    file://weston.ini \
    file://axelera-background.jpg \
    file://weston.service \
"

do_install:append() {
    install -d ${D}/usr/share/backgrounds/
    install -m 0644 ${WORKDIR}/axelera-background.jpg ${D}/usr/share/backgrounds/
}

do_install:append () {
	install -D -p -m0644 ${WORKDIR}/weston.service ${D}${systemd_system_unitdir}/weston.service
	sed "s%#WESTON_USER#%${WESTON_USER}%g" -i ${D}${systemd_system_unitdir}/weston.service
}

FILES:${PN} =+ " \
    /usr/share/backgrounds/axelera-background.jpg \
"
