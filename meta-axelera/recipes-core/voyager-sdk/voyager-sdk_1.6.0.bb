SUMMARY = "Axelera AI's Voyager SDK"
DESCRIPTION = "\
    Support native execution of AI inference pipelines \
    on the Axelera Metis AIPU. \
"
LICENSE = "CLOSED"

SRC_URI += "file://OpenCL.pc"

do_install() {
    install -d "${D}${libdir}/pkgconfig"
    install -m 0644 ${WORKDIR}/OpenCL.pc ${D}${libdir}/pkgconfig/
}

FILES:${PN}-dev = ""
FILES:${PN} += "${libdir}/pkgconfig/OpenCL.pc"

RDEPENDS:${PN} = "\
    cairo-dev \
    ffmpeg-rockchip-dev \
    git \
    gobject-introspection-dev \
    grep \
    libva-dev \
    ninja \
    nlohmann-json-dev \
    opencl-headers \
    opencv-dev \
    opencv-staticdev \
    packagegroup-core-buildessential \
    procps \
    python3-dev \
    rockchip-libmali-dev \
    simde-dev \
    wget \
"

INSANE_SKIP:${PN} = "dev-deps"
