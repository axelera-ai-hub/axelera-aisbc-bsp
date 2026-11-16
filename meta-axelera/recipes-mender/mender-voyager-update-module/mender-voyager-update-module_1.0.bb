SUMMARY = "Voyager mender update module"
DESCRIPTION = "Installs a mender module used for updating Voyager BSP."

SECTION = "base"
LICENSE = "CLOSED"

RDEPENDS:${PN} += "\
    jq \
    mender-update \
    python3-core \
"

SRC_URI = " \
    file://mender-update \
    file://voyager-version-check.py \
"

S = "${WORKDIR}"

do_install() {
    install -d "${D}"/"${datadir}"/mender/modules/v3
    install -m 0775 "${WORKDIR}"/mender-update "${D}"/"${datadir}"/mender/modules/v3/mender-update
    install -m 0755 "${WORKDIR}"/voyager-version-check.py "${D}"/"${datadir}"/mender/modules/v3/voyager-version-check.py
}

FILES:${PN} += "${datadir}/mender/modules/v3/*"
