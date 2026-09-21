SUMMARY = "No-op sudo stand-in"
DESCRIPTION = "Vendor tooling invokes sudo unconditionally. This image has no \
sudo, but when logged in as root those calls fail for no reason. This \
package installs a spoof that strips sudo's own options and execs the rest. \
It grants no privilege: it is installed 0750 under ${sbindir}, which is on \
root's PATH but not on an unprivileged user's, and it refuses to run as \
non-root rather than returning success without having escalated anything."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://sudo-spoof"

S = "${WORKDIR}"

RPROVIDES:${PN}  = "sudo"
RCONFLICTS:${PN} = "sudo"
RREPLACES:${PN}  = "sudo"

do_install() {
    install -d ${D}${sbindir}
    install -m 0750 ${WORKDIR}/sudo-spoof ${D}${sbindir}/sudo
}

FILES:${PN} = "${sbindir}/sudo"
