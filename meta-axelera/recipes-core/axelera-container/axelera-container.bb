SUMMARY = "Axelera docker container recipe"
DESCRIPTION = "Recipe to add support for Axelera container to system image"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI += " \
    file://setup_axelera_environment.sh \
    file://start_axelera.py \
"

do_install () {
    install -d ${D}/home/firefly/
    install -m 0755 ${WORKDIR}/setup_axelera_environment.sh ${D}/home/firefly/setup_axelera_environment.sh
    install -m 0755 ${WORKDIR}/start_axelera.py ${D}/home/firefly/start_axelera.py
}

FILES:${PN} += " \
    /home/firefly/setup_axelera_environment.sh \
    /home/firefly/start_axelera.py \
"
