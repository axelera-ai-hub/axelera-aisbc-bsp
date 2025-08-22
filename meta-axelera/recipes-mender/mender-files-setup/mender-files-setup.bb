SUMMARY = "Mender files setup recipe"
DESCRIPTION = "Recipe to add Mender files and directories to the image"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FACTORY_DIR = "/factory"
DATA_DIR = "/data"
MENDER_DATA_DIR = "${DATA_DIR}/mender"
MENDER_FACTORY_DIR = "${FACTORY_DIR}/mender"
MENDER_DEVICE_TYPE ?= "default"

RDEPENDS:${PN} = "mender-client"

inherit systemd

SRC_URI += "\
    file://mender-files-setup.sh.in \
    file://mender-files-setup.service \
"

do_install() {
    install -d "${D}${MENDER_DATA_DIR}"
    install -d "${D}${MENDER_FACTORY_DIR}"

    rm -f "${D}${MENDER_DATA_DIR}/mender.conf"
    ln -sf /etc/mender/mender.conf ${D}${MENDER_DATA_DIR}/mender.conf

    echo "device_type=${MENDER_DEVICE_TYPE}" > ${WORKDIR}/device_type
    install -m 0644 ${WORKDIR}/device_type ${D}${MENDER_FACTORY_DIR}/device_type

    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/mender-files-setup.service ${D}${systemd_unitdir}/system/

    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/mender-files-setup.sh.in ${D}${bindir}/mender-files-setup.sh

    sed -i -e 's,@@MENDER_DATA_DIR@@,${MENDER_DATA_DIR},g' "${D}${bindir}/mender-files-setup.sh"
    sed -i -e 's,@@MENDER_FACTORY_DIR@@,${MENDER_FACTORY_DIR},g' "${D}${bindir}/mender-files-setup.sh"
}

FILES:${PN} += "\
    /data \
    /factory \
    ${systemd_unitdir}/system/mender-files-setup.service \
"

SYSTEMD_SERVICE:${PN} = "mender-files-setup.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"
