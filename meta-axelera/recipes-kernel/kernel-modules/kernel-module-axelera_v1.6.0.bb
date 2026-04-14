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

PV = "v1.6.0"

SRC_URI = " \
    git://github.com/axelera-ai-hub/axelera-driver;protocol=https;branch=release/v1.6 \
    file://check_pcie_device.sh \
    file://pcie-check.service \
"

SRC_URI[sha256sum] = "ecc224ab5121162a2f26a160153480cb8e84deee482b015c5eaacadc64942a37"
SRCREV = "a98a609514b16cf2e0ff749d5676bbaf5bde93aa"
S = "${WORKDIR}/git"

EXTRA_OEMAKE = "CROSS_COMPILE=${TARGET_PREFIX} SYSROOT=${STAGING_DIR_TARGET}"
INHIBIT_PACKAGE_STRIP = "1"

inherit module

EXTRA_OEMAKE = "KDIR=${STAGING_KERNEL_BUILDDIR}"

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
