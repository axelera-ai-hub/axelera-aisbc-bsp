FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = "file://post-install-script;subdir=${BPN}-${PV} \
          file://LICENSE;subdir=${BPN}-${PV} \
          "

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit mender-state-scripts

ALLOW_EMPTY:${PN} = "1"

do_install() {
    install -m 0775 ${S}/post-install-script ${MENDER_STATE_SCRIPTS_DIR}/ArtifactInstall_Leave_99_post_install
}
