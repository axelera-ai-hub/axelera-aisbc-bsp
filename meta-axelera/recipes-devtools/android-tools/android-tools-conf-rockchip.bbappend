# meta-rockchip touches /var/usb-debugging-enabled which was
# changed in later versions of kirkstone to /etc/usb-debugging-enabled

FILESEXTRAPATHS:prepend:axelera-machine := "${THISDIR}/files:"

SRC_URI:append:axelera-machine = "file://android-gadget-setup"

do_install:append:axelera-machine() {
	if [ "${USB_DEBUGGING_ENABLED}" = "1" ]; then
		install -d ${D}/etc
		touch ${D}/etc/usb-debugging-enabled
	fi
}
