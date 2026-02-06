FILESEXTRAPATHS:prepend:axelera-machine := "${THISDIR}/files:"

SRC_URI:append:axelera-machine = " \
        file://0001-Do-not-build-tests.patch; \
"
