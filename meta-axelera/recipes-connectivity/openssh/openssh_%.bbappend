FILESEXTRAPATHS:prepend:axelera-machine := "${THISDIR}/files:"

SRC_URI:append:axelera-machine = " \
    file://sshd_config_readonly \
    file://sshdgenkeys.service \
"

do_install:append:axelera-machine() {
    install -d ${D}${sysconfdir}/ssh
    install -m 0644 ${WORKDIR}/sshd_config_readonly ${D}${sysconfdir}/ssh/sshd_config_readonly
    rm -rf ${D}${sysconfdir}/ssh/sshd_config
    ln -s ${sysconfdir}/ssh/sshd_config_readonly ${D}${sysconfdir}/ssh/sshd_config
}
