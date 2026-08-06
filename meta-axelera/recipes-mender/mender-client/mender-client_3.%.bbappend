# We don't want mender-client service to run. Local file system updates only.
FILESEXTRAPATHS:prepend:axelera-machine := "${THISDIR}/files:"

SRC_URI:append:axelera-machine = " \
    file://mender.conf \
    file://dev-public.key \
"

AXE_MENDER_ARTIFACT_PUBKEY ?= "${WORKDIR}/dev-public.key"

do_install:append:axelera-machine() {
    install -d ${D}/${sysconfdir}/mender
    install -m 0600 ${AXE_MENDER_ARTIFACT_PUBKEY} ${D}/${sysconfdir}/mender/artifact-verify-key.pem
}

SYSTEMD_AUTO_ENABLE = "disable"
