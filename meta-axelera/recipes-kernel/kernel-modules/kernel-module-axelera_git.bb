SUMMARY = "Driver/low-level API for the PCIe interface of the Metis device."
DESCRIPTION = "\
    This is a driver/low-level API and test command for the PCIe \
    interface of the Metis device. The source code contains several \
    tools and binaries. However; this recipe only builds the kernel \
    driver."

HOMEPAGE = "https://github.com/axelera-ai/host.pcie-driver"
BUGTRACKER = "https://github.com/axelera-ai/host.pcie-driver/issues"
SECTION = "kernel-modules"
CVE_PRODUCT = "axelera"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://LICENSE;md5=4641e94ec96f98fabc56ff9cc48be14b"

SRC_URI = " \
    ${REMOTE_DRIVER};protocol=ssh;branch=release/v1.1.0 \
    file://0001-cross-compile-fixups.patch \
"

SRC_URI:append:antelao-3588 = " \
    file://check_pcie_device.sh \
    file://pcie-check.service \
"

SRC_URI[sha256sum] = "ad2598304a8af697d0c335a50a3e5a1ba06c82d9b63ef5f9d3e730b54cf9148a"
SRCREV = "dcd72e2349965c8726bae3e53155b526ee30d121"
S = "${WORKDIR}/git/os/driver"

EXTRA_OEMAKE = "CROSS_COMPILE=${TARGET_PREFIX} SYSROOT=${STAGING_DIR_TARGET}"
INHIBIT_PACKAGE_STRIP = "1"
export KERNEL_PATH="${STAGING_KERNEL_DIR}"

inherit module

do_install() {
    install -d ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/kernel/drivers/axelera
    install -m 644 ${S}/*.ko ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/kernel/drivers/axelera/

}

do_install:append:antelao-3588() {
    install -d ${D}${systemd_system_unitdir}
    install -d ${D}/usr/local/bin

    install -m 0755 ${WORKDIR}/check_pcie_device.sh ${D}/usr/local/bin
    install -m 0644 ${WORKDIR}/pcie-check.service ${D}${systemd_system_unitdir}
}

COMPATIBLE_MACHINE = "(itx-3588j|antelao-3588)"
CLEANBROKEN = "1"
RPROVIDES:${PN} += "kernel-module-axl-pcie-reset kernel-module-dmabuf-triton-exporter kernel-module-dmabuf-triton-importer kernel-module-metis"

inherit systemd

SYSTEMD_SERVICE:${PN}:antelao-3588 = "pcie-check.service"

FILES:${PN}:antelao-3588 += " \
    /usr/local/bin/check_pcie_device.sh \
    ${systemd_system_unitdir}/pcie-check.service \
"

SYSTEMD_AUTO_ENABLE:antelao-3588 = "enable"

BBCLASSEXTEND =+ "native nativesdk"
