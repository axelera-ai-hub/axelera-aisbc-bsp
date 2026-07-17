FILESEXTRAPATHS:prepend:axelera-machine := "${THISDIR}/files:${THISDIR}/files/voyager:"

SRC_URI:append:axelera-machine = "\
    file://file_contexts.subs \
    file://0001-allow-mount-anyfile.patch \
    file://metadata.xml \
    file://voyager.fc \
    file://voyager.if \
    file://voyager.te \
    "

DEFAULT_ENFORCING:axelera-machine = "permissive"

do_configure:prepend:axelera-machine() {
    mkdir -p ${S}/policy/modules/voyager
    cp ${WORKDIR}/metadata.xml ${S}/policy/modules/voyager/
    cp ${WORKDIR}/voyager.te ${S}/policy/modules/voyager/
    cp ${WORKDIR}/voyager.fc ${S}/policy/modules/voyager/
    cp ${WORKDIR}/voyager.if ${S}/policy/modules/voyager/
}

do_configure:append:axelera-machine() {
    if [ -f ${S}/policy/modules.conf ]; then
        if grep -q "^voyager" ${S}/policy/modules.conf; then
            sed -i 's/^voyager =.*/voyager = module/' ${S}/policy/modules.conf
        else
            echo "voyager = module" >> ${S}/policy/modules.conf
        fi
    fi
}

do_install:append:axelera-machine() {
    install -d ${D}${sysconfdir}/selinux/targeted/contexts/files
    install -m 0644 ${WORKDIR}/file_contexts.subs ${D}${sysconfdir}/selinux/targeted/contexts/files
}
