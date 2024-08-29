DESCRIPTION = "Firefly Fan Service"

LICENSE = "CLOSED"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = " \
	file://firefly_fan_control \
	file://firefly-fan-init \
	file://firefly-fan.service \
"

inherit systemd

SYSTEMD_SERVICE:${PN} = "firefly-fan.service"

do_install() {
	install -d ${D}${bindir}
	install -d ${D}${systemd_system_unitdir}
	install -m 0755 ${WORKDIR}/firefly_fan_control ${D}${bindir}/
	install -m 0755 ${WORKDIR}/firefly-fan-init ${D}${bindir}/
	install -m 644 ${WORKDIR}/firefly-fan.service ${D}${systemd_system_unitdir}
}

FILES:${PN} += " \
	${systemd_system_unitdir}/firefly-fan.service \
	${bindir}/firefly_fan_control \
	${bindir}/firefly-fan-init \
"

SYSTEMD_AUTO_ENABLE = "enable"
