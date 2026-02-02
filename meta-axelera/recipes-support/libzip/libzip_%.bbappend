do_install:append() {
    ln -s libzip.so.5 ${D}${libdir}/libzip.so.4
}

FILES:${PN} += "${libdir}/libzip.so.4"
