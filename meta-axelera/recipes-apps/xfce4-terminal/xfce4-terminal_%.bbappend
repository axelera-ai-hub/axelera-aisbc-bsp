FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://terminalrc"

do_install:append() {
    install -d "${D}/home/${WESTON_USER}/.config/xfce4/terminal"
    install -m 0664 "${WORKDIR}/terminalrc" "${D}/home/${WESTON_USER}/.config/xfce4/terminal/terminalrc"
}

FILES:${PN} += "/home/${WESTON_USER}/.config/xfce4/terminal/terminalrc"
