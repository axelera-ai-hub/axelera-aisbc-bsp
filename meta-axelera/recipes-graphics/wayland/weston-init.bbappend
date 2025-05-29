FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = "\
    file://weston.ini \
    file://axelera-background.jpg \
    file://weston-firefly.service \
    file://weston-antelao.service \
"

do_install:append() {
    install -d ${D}/usr/share/backgrounds/
    install -m 0644 ${WORKDIR}/axelera-background.jpg ${D}/usr/share/backgrounds/
}

do_install:append:antelao-3588 () {
	install -D -p -m0644 ${WORKDIR}/weston-antelao.service ${D}${systemd_system_unitdir}/weston.service
}

do_install:append:itx-3588j() {
	install -D -p -m0644 ${WORKDIR}/weston-firefly.service ${D}${systemd_system_unitdir}/weston.service
}

FILES:${PN} =+ " \
    /usr/share/backgrounds/axelera-background.jpg \
"
