SUMMARY = "Axelera configuration files for udev."
DESCRIPTION = "\
    Installs the .rules files in the files directory to /etc/udev/rules.d. \
    Add more .rules files to the files directory and the SRC_URI to install more \
    udev rules."

HOMEPAGE = "https://www.axelera.ai/"
BUGTRACKER = "https://www.axelera.ai/"
SECTION = "udev-rules"
CVE_PRODUCT = "axelera"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
PROVIDES:${PN} += "udev-conf-axelera"

SRC_URI = "\
    file://72-triton.rules \
"

inherit allarch

do_install[nostamp] = "1"
do_unpack[nostamp] = "1"

do_install() {
    install -d ${D}${nonarch_base_libdir}/udev/rules.d
    for file in ${SRC_URI}; do
        filename=$(basename ${file})
        install -m 0644 ${WORKDIR}/${filename} ${D}${nonarch_base_libdir}/udev/rules.d
    done
}

PACKAGES = "${PN}"
FILES:${PN} += "${nonarch_base_libdir}/udev/rules.d/*"
COMPATIBLE_MACHINE = "(itx-3588j|antelao-3588)"
BBCLASSEXTEND =+ "native nativesdk"
