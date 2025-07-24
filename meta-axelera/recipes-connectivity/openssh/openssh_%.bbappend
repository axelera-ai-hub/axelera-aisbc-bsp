FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://sshd_config \
    file://sshd.service \
    file://sshdgenkeys.service \
"

do_install:append() {
    install -d ${D}${sysconfdir}/ssh
    install -m 0644 ${WORKDIR}/sshd_config ${D}${sysconfdir}/ssh/sshd_config
    install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
    ln -s ${systemd_unitdir}/system/sshd.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/sshd.service
}
