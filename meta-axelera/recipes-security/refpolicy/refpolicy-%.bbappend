FILESEXTRAPATHS:prepend:axelera-machine := "${THISDIR}/files:"

SRC_URI:append:axelera-machine = "file://file_contexts.subs"

DEFAULT_ENFORCING:axelera-machine = "permissive"

do_install:append:axelera-machine() {
    install -d ${D}${sysconfdir}/selinux/targeted/contexts/files
    install -m 0644 ${WORKDIR}/file_contexts.subs ${D}${sysconfdir}/selinux/targeted/contexts/files
}
