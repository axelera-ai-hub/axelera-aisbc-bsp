DESCRIPTION = "First boot script service which extends the partition"
LICENSE = "CLOSED"

SRC_URI = "file://auto-extend-partition.sh \
           file://auto-extend-partition.service"

S = "${WORKDIR}"

RDEPENDS:${PN} = "e2fsprogs-resize2fs"

inherit systemd

do_install() {
    install -d ${D}${bindir}
    install -d ${D}${systemd_unitdir}/system

    install -m 0755 ${WORKDIR}/auto-extend-partition.sh ${D}${bindir}/
    install -m 0644 ${WORKDIR}/auto-extend-partition.service ${D}${systemd_unitdir}/system/
}

FILES:${PN} += "${systemd_unitdir}/system/auto-extend-partition.service"

SYSTEMD_SERVICE:${PN} = "auto-extend-partition.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"
