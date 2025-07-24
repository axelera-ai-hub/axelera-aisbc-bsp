FILESEXTRAPATHS:prepend:itx-3588j := "${THISDIR}/libubootenv:"

SRC_URI:append:itx-3588j = " \
  file://fw_env.config.itx-3588j; \
"

do_install:append:itx-3588j() {
  install -d ${D}${sysconfdir}
  install -m 0644 ${WORKDIR}/fw_env.config.itx-3588j ${D}${sysconfdir}/fw_env.config
}

FILES:${PN} += " ${sysconfdir}/fw_env.config"
