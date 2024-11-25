SUMMARY = "Axelera docker container recipe"
DESCRIPTION = "Recipe to import container to system image"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI += " \
    https://amarula-share.s3.eu-central-1.amazonaws.com/release/v1.0.0-a6/sdk-docker-image-build-ubuntu-22.04-arm64/axelera-sdk-ubuntu-2204-arm64.tar;md5sum=15c4976b3a294414f32997d68252da5f;unpack=0 \
    file://start_axelera.py \
"

do_install () {
    install -d ${D}/home/firefly/
    install -m 0755 ${WORKDIR}/axelera-sdk-ubuntu-2204-arm64.tar ${D}/home/firefly/axelera-sdk-ubuntu-2204-arm64.tar
    install -m 0755 ${WORKDIR}/start_axelera.py ${D}/home/firefly/start_axelera.py
}

FILES:${PN} += " \
    /home/firefly/axelera-sdk-ubuntu-2204-arm64.tar \
    /home/firefly/start_axelera.py \
"
