# meta-rockchip touches /var/usb-debugging-enabled which was
# changed in later versions of kirkstone to /etc/usb-debugging-enabled
do_install:append() {
	if [ "${USB_DEBUGGING_ENABLED}" = "1" ]; then
		install -d ${D}/etc
		touch ${D}/etc/usb-debugging-enabled
	fi
}
