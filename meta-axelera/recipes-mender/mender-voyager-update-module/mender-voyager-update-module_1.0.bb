SUMMARY = "Voyager mender update module"
DESCRIPTION = "Installs a mender module used for updating Voyager BSP."

SECTION = "base"
LICENSE = "CLOSED"

RDEPENDS:${PN} += "\
    jq \
    mender-client \
"

SRC_URI = "file://mender-update"
S = "${WORKDIR}"

do_install() {
    install -d "${D}"/"${datadir}"/mender/modules/v3
    install -m 0775 "${WORKDIR}"/mender-update "${D}"/"${datadir}"/mender/modules/v3/mender-update
}

FILES:${PN} += "${datadir}/mender/modules/v3/mender-update"
