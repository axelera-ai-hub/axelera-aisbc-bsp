DESCRIPTION = "A command-line tool to test USB connections using the PassMark USB 3.0 loopback plug."
HOMEPAGE = "https://github.com/dimhoff/u3loop"
LICENSE = "MIT"
LIC_FILES_CHKSUM="file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "libusb1"

SRC_URI = " \
    git://github.com/dimhoff/u3loop.git;protocol=http;branch=master; \
"

SRCREV = "11271eb59d4626ffdd9fec8c5a022f7064b9e963"

S = "${WORKDIR}/git"

do_compile() {
    ${CC} u3loop.c -o u3loop -I${STAGING_INCDIR}/libusb-1.0 ${CFLAGS} ${LDFLAGS} -lusb-1.0 -lrt
    ${CC} u3bench.c -o u3bench -I${STAGING_INCDIR}/libusb-1.0 ${CFLAGS} ${LDFLAGS} -lusb-1.0 -lrt
}

do_install() {
    oe_runmake install DESTDIR=${D} PREFIX=${prefix}
}

FILES:${PN} += "${bindir}/u3loop ${bindir}/u3bench ${sysconfdir}/udev/rules.d/99-u3loop.rules"
