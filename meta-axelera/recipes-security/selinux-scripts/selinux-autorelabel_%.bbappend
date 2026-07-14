FILESEXTRAPATHS:prepend:axelera-machine := "${THISDIR}/files:"

SRC_URI:append:axelera-machine = " \
    file://selinux-autorelabel.sh \
"

do_install:append:axelera-machine() {
    install -d -m 755 ${D}${bindir}
    install -m 755 ${WORKDIR}/selinux-autorelabel.sh ${D}${bindir}/selinux-autorelabel.sh
}
