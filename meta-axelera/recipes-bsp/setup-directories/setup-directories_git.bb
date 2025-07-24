SUMMARY = "setup directories startup service"
DESCRIPTION = "Installs the setup-directories.service file. \
               This service calls /usr/bin/setup_directories \
               on every startup. \
"

SECTION = "base"
LICENSE = "CLOSED"
SRC_URI = "\
    file://setup-directories.service \
    file://setup_directories \
"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/data
    install -d ${D}/factory

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/setup-directories.service ${D}${systemd_system_unitdir}

    install -d -m 755 ${D}${bindir}
    install -m 755 ${WORKDIR}/setup_directories ${D}${bindir}/setup_directories
}

inherit systemd

SYSTEMD_SERVICE:${PN} = "setup-directories.service"
FILES:${PN} += "/data /factory ${bindir}/setup_directories"

BBCLASSEXTEND = "native nativesdk"
