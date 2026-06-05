SUMMARY = "Rockchip OP-TEE Client"
DESCRIPTION = "Prebuilt OP-TEE v2 binaries."
LICENSE = "CLOSED"

inherit systemd

SRC_URI = "\
    ${REMOTE_REPOS_PREFIX}optee-rockchip;protocol=ssh;branch=master \
    file://tee-supplicant.service \
"

SRCREV = "bf8d67f6e8e8b269e0198b45353440ba78c2b881"

do_install:append() {
    install -d ${D}${libdir}
    cp -rP ${WORKDIR}/git/bin/optee_v2/lib/arm64/*.so* ${D}${libdir}/
    chmod 0755 ${D}${libdir}/*.so*

    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/git/bin/optee_v2/lib/arm64/tee-supplicant ${D}${bindir}/

    install -d ${D}${includedir}
    install -m 0644 ${WORKDIR}/git/bin/optee_v2/include/*.h ${D}${includedir}/

    install -d ${D}${nonarch_base_libdir}/optee_armtz
    install -m 0444 ${WORKDIR}/git/bin/optee_v2/ta/4367fd45-4469-42a6-925d-3857b952704a.ta ${D}${nonarch_base_libdir}/optee_armtz/

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/tee-supplicant.service ${D}${systemd_system_unitdir}/
}

SYSTEMD_SERVICE:${PN} = "tee-supplicant.service"

FILES:${PN} += "${nonarch_base_libdir}/optee_armtz/*.ta"

SOLIBS = ".so*"
FILES_SOLIBSDEV = ""

INSANE_SKIP:${PN} += "already-stripped"

RPROVIDES:${PN} += "optee-client"
RREPLACES:${PN} += "optee-client"
RCONFLICTS:${PN} += "optee-client"

INHIBIT_PACKAGE_STRIP = "1"
