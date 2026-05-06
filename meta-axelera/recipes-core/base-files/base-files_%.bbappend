FILESEXTRAPATHS:prepend:axelera-machine := "${THISDIR}/files:"

SRC_URI:append:axelera-machine = " \
    file://fstab \
    file://rusticl.sh \
"

do_install:append:axelera-machine () {
    install -d ${D}${sysconfdir}/profile.d
    install -m 0644 ${WORKDIR}/rusticl.sh ${D}${sysconfdir}/profile.d/rusticl.sh
    echo "RUSTICL_ENABLE=panthor" >> ${D}${sysconfdir}/environment
}
