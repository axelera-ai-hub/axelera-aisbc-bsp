FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://fw_env.config; \
"

do_install:append() {
  install -d ${D}${sysconfdir}
  install -m 0644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config
}

FILES:${PN} += "${sysconfdir}/fw_env.config"
COMPATIBLE_MACHINE = "(itx-3588j|antelao-3588)"
