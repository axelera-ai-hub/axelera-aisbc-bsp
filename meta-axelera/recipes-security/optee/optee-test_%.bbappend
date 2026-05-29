FILESEXTRAPATHS:prepend := "${THISDIR}/optee-test:"

SRC_URI += "file://oem_privkey.pem"

EXTRA_OEMAKE += "TA_SIGN_KEY=${WORKDIR}/oem_privkey.pem"

COMPATIBLE_MACHINE = "(antelao-3588|itx-3588j)"
