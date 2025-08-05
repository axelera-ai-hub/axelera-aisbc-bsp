FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://fw_env.config; \
"

# The default behavior of mender is to install fw_env.config to /data/u-boot.
# This is undesirable as these values are already hardcoded and will not
# change. Remove the mender provided symlinks and auto-generated
# fw_env.config file and copy the one in the libubootenv directory.
#
# The libubootenv_%.bbappend file in meta-mender overwrites the fw_env.config
# provided in this recipe. As such, we install the fw_env.config directly from
# this directory.
FW_ENV_CONFIG_DIR := "${THISDIR}/libubootenv"

do_install:append() {
  rm -rf ${D}${sysconfdir}/fw_env.config
  rm -rf ${D}/data
  install -d ${D}${sysconfdir}
  install -m 0644 ${FW_ENV_CONFIG_DIR}/fw_env.config ${D}${sysconfdir}/fw_env.config
}

FILES:${PN} += "${sysconfdir}/fw_env.config"
COMPATIBLE_MACHINE = "(itx-3588j|antelao-3588)"
