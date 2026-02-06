do_install:append:axelera-machine() {
    ln -s libzip.so.5 ${D}${libdir}/libzip.so.4
}

FILES:${PN} += "${libdir}/libzip.so.4"
