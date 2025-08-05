SUMMARY = "mender-commit-check service and script"
DESCRIPTION = "Normally, on a successful boot, the mender-update service \
               auto-runs mender-update commit. However, as mender runs in \
               standalone mode, there is a need to auto-check if an update \
               was ran on startup. The mender-commit-check runs on boot and \
               checks if /var/lib/mender/boot_attempted exists and if so, \
               runs /usr/bin/mender-update commit and cleans up artifact \
               script directories as well. \
              "
SECTION = "base"
LICENSE = "CLOSED"

SRC_URI = "\
    file://mender-commit-check.service \
    file://mender-commit-check \
"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/mender-commit-check.service ${D}${systemd_system_unitdir}

    install -d -m 755 ${D}${bindir}
    install -m 755 ${WORKDIR}/mender-commit-check ${D}${bindir}/mender-commit-check
}

inherit systemd

SYSTEMD_SERVICE:${PN} = "mender-commit-check.service"
FILES:${PN} += "${bindir}/mender-commit-check"

BBCLASSEXTEND = "native nativesdk"
