SUMMARY = "USB testing utility from the Linux kernel sources"
DESCRIPTION = " \
    This program issues ioctls to perform the tests implemented by the \
    kernel driver.  It can generate a variety of transfer patterns; you \
    should make sure to test both regular streaming and mixes of \
    transfer sizes (including short transfers). \
"
HOMEPAGE = "http://www.linux-usb.org/usbtest/"

LICENSE = "GPL-2.0-only"

DEPENDS = "virtual/kernel"

inherit kernelsrc kernel-arch

S = "${WORKDIR}/${BP}"

do_configure[depends] += "virtual/kernel:do_shared_workdir"

TESTUSB_SRC = " \
    arch/${ARCH}/Makefile \
    tools/arch \
    tools/build \
    tools/include \
    tools/lib \
    tools/scripts \
    tools/Makefile \
    tools/usb \
"

do_configure[prefuncs] += "copy_testusb_source_from_kernel"
python copy_testusb_source_from_kernel() {
    sources = (d.getVar("TESTUSB_SRC") or "").split()
    src_dir = d.getVar("STAGING_KERNEL_DIR")
    dest_dir = d.getVar("S")
    bb.utils.mkdirhier(dest_dir)
    bb.utils.prunedir(dest_dir)
    for s in sources:
        src = oe.path.join(src_dir, s)
        dest = oe.path.join(dest_dir, s)
        if not os.path.exists(src):
            bb.warn("Path does not exist: %s. Maybe TESTUSB_SRC lists more files than what your kernel version provides and needs." % src)
            continue
        if os.path.isdir(src):
            oe.path.copyhardlinktree(src, dest)
        else:
            src_path = os.path.dirname(s)
            os.makedirs(os.path.join(dest_dir,src_path),exist_ok=True)
            bb.utils.copyfile(src, dest)
}

EXTRA_OEMAKE = "\
    -C ${S}/tools/usb \
    HOSTCC="${BUILD_CC}" \
    V=1 \
"

do_compile() {
    if [ ! -f "${S}/tools/usb/Makefile" ]; then
        bbfatal "Makefile for testusb not found in ${S}/tools/usb. Source copy likely failed. STAGING_KERNEL_DIR='${STAGING_KERNEL_DIR}'. TESTUSB_SRC='${TESTUSB_SRC}'."
    fi
    oe_runmake testusb
}

do_install() {
    if [ ! -f "${S}/tools/usb/testusb" ]; then
        bbfatal "testusb binary not found in ${S}/tools/usb. Compilation likely failed."
    fi
    install -d ${D}${bindir}
    install -m 0755 ${S}/tools/usb/testusb ${D}${bindir}/
}
