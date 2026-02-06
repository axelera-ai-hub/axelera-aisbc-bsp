SUMMARY = "Axelera docker container recipe"
DESCRIPTION = "Recipe to add support for Axelera container to system image"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI += " \
    file://setup_axelera_environment.sh \
    file://start_axelera.py \
"

HOMEDIR:antelao-3588 = "/home/antelao"
HOMEDIR:itx-3588j = "/home/firefly"

do_install () {
    install -d ${D}${HOMEDIR}
    install -m 0775 -d ${D}${HOMEDIR}/shared/
    install -m 0755 ${WORKDIR}/setup_axelera_environment.sh ${D}${HOMEDIR}/setup_axelera_environment.sh
    install -m 0755 ${WORKDIR}/start_axelera.py ${D}${HOMEDIR}/start_axelera.py
}

FILES:${PN} += " \
    ${HOMEDIR}/setup_axelera_environment.sh \
    ${HOMEDIR}/start_axelera.py \
    ${HOMEDIR}/shared/ \
"
