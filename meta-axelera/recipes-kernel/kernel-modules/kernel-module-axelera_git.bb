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

# SRC_URI = "git://git@github.com/axelera-ai/host.pcie-driver.git;protocol=ssh;branch=release/v0.9.0"
SRC_URI = "git://gitea@gitea.amarulasolutions.com:38745/axelera/host.pcie-driver.git;protocol=ssh;branch=release/v0.9.0"
SRC_URI[sha256sum] = "6ddf3356b259929843f61f9891fcbd7143ebab88f8c83ee56832075eef496f12"
SRCREV = "14066c0fff9b6b11c8efd804670421f696d266d6"
S = "${WORKDIR}/git/os/driver"

EXTRA_OEMAKE = "CROSS_COMPILE=${TARGET_PREFIX} SYSROOT=${STAGING_DIR_TARGET}"
INHIBIT_PACKAGE_STRIP = "1"
export KERNEL_PATH="${STAGING_KERNEL_DIR}"

inherit auto-patch module

do_install(){
    install -d ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/kernel/drivers/axelera
    install -m 644 ${S}/*.ko ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/kernel/drivers/axelera/
}

COMPATIBLE_MACHINE = "itx-3588j"
CLEANBROKEN = "1"
RPROVIDES:${PN} += "kernel-module-axl-pcie-reset kernel-module-dmabuf-triton-exporter kernel-module-dmabuf-triton-importer kernel-module-metis"

BBCLASSEXTEND =+ "native nativesdk"
