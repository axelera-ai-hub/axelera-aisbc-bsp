FILESEXTRAPATHS:prepend:axelera-machine := "${THISDIR}/files:"

SRC_URI:append:axelera-machine = "\
    file://0001-docker.service-Drop-the-dependency-from-network-wait.patch;patchdir=src/import; \
    file://daemon.json; \
    file://docker.service; \
"

do_install:append:axelera-machine() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/docker.service ${D}${systemd_system_unitdir}
    install -d ${D}/${sysconfdir}/docker
    install -m 0644 ${WORKDIR}/daemon.json ${D}/${sysconfdir}/docker/daemon.json
}
