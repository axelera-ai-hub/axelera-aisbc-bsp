FILESEXTRAPATHS:prepend:axelera-machine := "${THISDIR}/files:"

SRC_URI:append:axelera-machine = " file://terminalrc"

do_install:append:axelera-machine() {
    install -d "${D}/home/${WESTON_USER}/.config/xfce4/terminal"
    install -m 0664 "${WORKDIR}/terminalrc" "${D}/home/${WESTON_USER}/.config/xfce4/terminal/terminalrc"
}

FILES:${PN} += "/home/${WESTON_USER}/.config/xfce4/terminal/terminalrc"
