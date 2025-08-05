FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://sshd_config_readonly \
    file://sshdgenkeys.service \
"

do_install:append() {
    install -d ${D}${sysconfdir}/ssh
    install -m 0644 ${WORKDIR}/sshd_config_readonly ${D}${sysconfdir}/ssh/sshd_config_readonly
    rm -rf ${D}${sysconfdir}/ssh/sshd_config
    ln -s ${sysconfdir}/ssh/sshd_config_readonly ${D}${sysconfdir}/ssh/sshd_config
}
