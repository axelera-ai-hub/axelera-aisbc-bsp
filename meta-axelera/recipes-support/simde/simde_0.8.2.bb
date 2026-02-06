SUMMARY = "SIMD Everywhere"
DESCRIPTION = "Fast, portable implementations of SIMD intrinsics on hardware which doesn't natively support them"
HOMEPAGE = "https://github.com/simd-everywhere/simde"
BUGTRACKER = "https://github.com/simd-everywhere/simde/issues"
CVE_PRODUCT = "simde"

SECTION = "devel"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://COPYING;md5=b60de7db5b91c0b613d64e318151b0f1"

SRC_URI = "git://github.com/simd-everywhere/simde.git;protocol=https;branch=master"
SRCREV = "71fd833d9666141edcd1d3c109a80e228303d8d7"

S = "${WORKDIR}/git"

inherit meson pkgconfig

EXTRA_OEMESON = "-Dtests=false"

ALLOW_EMPTY:${PN} = "1"
