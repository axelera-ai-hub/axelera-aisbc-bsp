SUMMARY = "OP-TEE sanity testsuite, Rockchip fork"
DESCRIPTION = "xtest and its Trusted Applications from Rockchip's rk_tee_user"
HOMEPAGE = "https://www.op-tee.org/"

LICENSE = "BSD-2-Clause & GPL-2.0-only"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=daa2bcccc666345ab8940aab1315a4fa"

inherit python3native deploy
require recipes-security/optee/optee.inc

DEPENDS = "python3-pycryptodomex-native"

SRC_URI = "${REMOTE_REPOS_PREFIX}optee-rockchip;protocol=ssh;branch=master"
SRCREV = "bf8d67f6e8e8b269e0198b45353440ba78c2b881"
PV = "3.13"

S = "${WORKDIR}/git/rk_tee_user/v2"
B = "${WORKDIR}/build"

COMPATIBLE_MACHINE = "(antelao-3588|itx-3588j)"

TA_DEV_KIT_DIR = "${S}/export-ta_arm64"

# Directory with oem_privkey.pem. Leave empty to sign with Rockchip's
# test key, shipped in the dev kit.
AXE_OPTEE_TA_SIGN_KEY_DIR ?= ""
TA_SIGN_KEY_DIR = "${@'${AXE_OPTEE_TA_SIGN_KEY_DIR}' if d.getVar('AXE_OPTEE_TA_SIGN_KEY_DIR') else '${TA_DEV_KIT_DIR}/keys'}"

EXTRA_OEMAKE += " \
    TA_DEV_KIT_DIR=${TA_DEV_KIT_DIR} \
    OPTEE_CLIENT_EXPORT=${S}/client_export/ \
    CFG_PKCS11_TA=n \
    COMPILE_NS_USER=64 \
    CROSS_COMPILE_HOST=${HOST_PREFIX} \
    CROSS_COMPILE_TA=${HOST_PREFIX} \
    TA_SIGN_KEY=${TA_SIGN_KEY_DIR}/oem_privkey.pem \
    O=${B} \
"

CFLAGS += "-Wno-error=deprecated-declarations"

do_compile[file-checksums] += "${@'${AXE_OPTEE_TA_SIGN_KEY_DIR}/oem_privkey.pem:True' if d.getVar('AXE_OPTEE_TA_SIGN_KEY_DIR') else ''}"
do_compile() {
    cd ${S}
    # Top level makefile doesn't seem to handle parallel make gracefully
    oe_runmake xtest
    oe_runmake ta
    oe_runmake test_plugin
}
do_compile[cleandirs] = "${B}"

do_install () {
    install -D -p -m0755 ${B}/xtest/xtest ${D}${bindir}/xtest

    mkdir -p ${D}${nonarch_base_libdir}/optee_armtz/
    install -D -p -m0444 ${B}/ta/*/*.ta ${D}${nonarch_base_libdir}/optee_armtz/
    mkdir -p ${D}${libdir}/tee-supplicant/plugins
    install -D -p -m0444 ${B}/supp_plugin/*.plugin ${D}${libdir}/tee-supplicant/plugins/
}

do_deploy() {
    install -d ${DEPLOYDIR}/${MLPREFIX}optee/ta
    install -m 644 ${B}/ta/*/*.elf ${DEPLOYDIR}/${MLPREFIX}optee/ta
}
addtask do_deploy before do_build after do_install

FILES:${PN} += " \
    ${nonarch_base_libdir}/optee_armtz/ \
    ${libdir}/tee-supplicant/plugins/ \
"

RDEPENDS:${PN} += "optee-rockchip"
RCONFLICTS:${PN} = "optee-test"

PACKAGE_ARCH = "${MACHINE_ARCH}"
