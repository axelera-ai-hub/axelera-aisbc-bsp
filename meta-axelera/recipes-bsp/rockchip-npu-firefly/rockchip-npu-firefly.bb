DESCRIPTION = "Firefly rknn Service"

LICENSE = "LICENSE.rockchip"
LIC_FILES_CHKSUM = "file://LICENSE;md5=ac8e7324c36d977f97238dc97a7042f3"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

PATCHPATH = "${CURDIR}/rockchip-npu-firefly"
inherit auto-patch

SRCREV = "rk3588/linux_yocto_release"

SRC_URI = " \
	git://gitlab.com/firefly-linux/external/rknpu2.git;protocol=https;nobranch=1;branch=rk3588/linux_yocto_release; \
	file://rknn_server.service \
"

PV = "1.0+git${SRCPV}"

inherit systemd

SYSTEMD_SERVICE:${PN} = "rknn_server.service"

DEPENDS:append = " bash cmake-native"
RDEPENDS:${PN} = "bash"

INSANE_SKIP:${PN} += "shebang-size dev-so already-stripped ldflags"

S = "${WORKDIR}/git"

do_compile () {
	cd ${S}/examples/rknn_yolov5_demo
	bash -c ./build-linux_RK3588.sh
	cd -
}

do_install:append() {
	install -d ${D}${bindir}
	install -d ${D}${libdir}
	install -d ${D}${systemd_system_unitdir}

	install -m 0755 ${S}/runtime/Linux/rknn_server/aarch64/usr/bin/rknn_server ${D}${bindir}
	install -m 0755 ${S}/runtime/Linux/rknn_server/aarch64/usr/bin/start_rknn.sh ${D}${bindir}
	install -m 0755 ${S}/runtime/Linux/rknn_server/aarch64/usr/bin/restart_rknn.sh ${D}${bindir}
	install -m 0644 ${S}/runtime/Linux/librknn_api/aarch64/librknnrt.so ${D}${libdir}/librknnrt.so.1
	install -m 0644 ${WORKDIR}/rknn_server.service ${D}${systemd_system_unitdir}
	cd ${D}${libdir}
	ln -sf librknnrt.so.1 librknnrt.so
	cd -
}

FILES:${PN}: += " \
	${bindir}/rknn_server \
	${bindir}/start_rknn.sh \
	${bindir}/restart_rknn.sh \
	${libdir}/librknnrt.so \
	${libdir}/librknnrt.so.1 \
	${systemd_system_unitdir}/rknn_server.service \
"

SYSTEMD_AUTO_ENABLE = "enable"
