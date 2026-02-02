SUMMARY = "Fast, portable implementations of SIMD intrinsics on hardware which doesn't natively support them"
HOMEPAGE = "https://github.com/simd-everywhere/simde"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "git://github.com/simd-everywhere/simde.git;protocol=https;branch=master"

# Tag v0.8.2
SRCREV = "71fd833d9666141edcd1d3c109a80e228303d8d7"

S = "${WORKDIR}/git"

inherit meson pkgconfig

ALLOW_EMPTY:${PN} = "1"
EXTRA_OEMESON = "-Dtests=false"
